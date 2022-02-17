     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Statement - Send data to MMMM')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE4657   - Midas SE Statement - Send data to MMMM            *
      *                                                               *
      *  Function:  This program sends the Statements in XML format   *
      *             to MMM.                                           *
      *                                                               *
      *  Called By   : SEC4651 - SE Statement Processing              *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD058195           Date 09Jun21               *
      *  Prev Amend No. CSE040             Date 10Mar21               *
      *                 MD056262           Date 10Mar21               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 221616             Date 23Sep03               *
      *                 CSE040  *CREATE    Date 18Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058195 - SEC4664 00001 fails during COB due to MQOPEN call.*
      *             Changed the call of IBM MQ functions from CALLP   *
      *             to CALL operation.                                *
      *  CSE040 - Securities Statement Processing                     *
      *           Applied for MD-55740                                *
      *  MD056262 - Allow MQseries to support Meridian 5 and 6        *
      *  MD046248 - Finastra Rebranding                               *
      *  221616 - Avoid sending empty message in data queue.          *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
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
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FCGUXMLPD  IP   E             DISK    INFSR(*PSSR)
     ** Midas CG UDC XML Merged Data

     FSDSESTPD  IF   E             DISK    INFSR(*PSSR)
     ** Midas SD ICD for Securities Statement

     FSES2MMPD  O    E             DISK    INFSR(*PSSR)
     ** Midas SE MT535/536/537 Data send to MMM

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** The standard SWIFT conversion translate SWIFT Invalid character in XML Invalid character
      ** To avoid problem, the invalid character is replaced by ' '.

     D InvChr          C                   '&;"{}ò!$¢%*@\#|¬`~_?<=>'            Invalid Character
     D RepChr          C                   '                       '            Replace Character

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Object Descriptor                                                                  MD056262
     D MQOD            DS                                                                   MD056262
     D/COPY QMQM/QRPGLESRC,CMQODG                                                           MD056262
                                                                                            MD056262
      ** Message Descriptor                                                                 MD056262
     D MQMD            DS                                                                   MD056262
     D/COPY QMQM/QRPGLESRC,CMQMDG                                                           MD056262
                                                                                            MD056262
      ** Put message options                                                                MD056262
     D MQPMO           DS                                                                   MD056262
     D/COPY QMQM/QRPGLESRC,CMQPMOG                                                          MD056262
                                                                                            MD056262
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                MD056262
                                                                                            MD056262
      ** External DS for SAR details                                                        MD056262
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   MD056262

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WkMsgDta        S          64512
      ** Message Data

     D MaxLength       S              5  0 INZ(%SIZE(WkMsgDta))
      ** Maximum message Length

     D WkLenMsg        S              5  0 INZ(0)
      ** Current message Length

     D WkLenData       S              5  0 INZ(0)
      ** Current Data Length

     D WkData          S            200
      ** Extract Data from file

     D WkTagValue      S                   LIKE(XMTAGV)
      ** Tag Value

     D @RUN            S              1
                                                                                            MD056262
      ** MQI Constants                                                                      MD056262
     D/COPY QMQM/QRPGLESRC,CMQG                                                             MD056262
                                                                                            MD056262
      ** MQ Parameters                                                                      MD056262
     D HCONN           S             10I 0                                                  MD056262
     D OCODE           S             10I 0                                                  MD056262
     D REASON          S             10I 0                                                  MD056262
     D OPTS            S             10I 0                                                  MD056262
     D HIN             S             10I 0                                                  MD056262
     D CCODE           S             10I 0                                                  MD056262
     D P@MsgLen        S             10I 0                                                  MD056262
     D MESLEN          S             10I 0                                                  MD056262
     D P@MsgBuf        S          32000                                                     MD056262
     D w@null          S              1    INZ(x'00')                                       MD056262
                                                                                            MD056262
      ** System Values                                                                      MD056262
     D PRTCD           S              7A                                                    MD056262
     D PSysVal01       S             20A   INZ('MQQueueMgr          ')                      MD056262
     D PCurSet01       S            200A                                                    MD056262
     D PSysVal02       S             20A   INZ('MidasQueueNameMT53n ')                      MD056262
     D PCurSet02       S            200A                                                    MD056262
     D PSysVal03       S             20A                                                    MD056262
     D PCurSet03       S            200A                                                    MD056262
     D PSysVal04       S             20A                                                    MD056262
     D PCurSet04       S            200A                                                    MD056262
     D PSysVal05       S             20A                                                    MD056262
     D PCurSet05       S            200A                                                    MD056262
     D PSysVal06       S             20A                                                    MD056262
     D PCurSet06       S            200A                                                    MD056262
     D PSysVal07       S             20A                                                    MD056262
     D PCurSet07       S            200A                                                    MD056262
     D PSysVal08       S             20A                                                    MD056262
     D PCurSet08       S            200A                                                    MD056262
     D PSysVal09       S             20A                                                    MD056262
     D PCurSet09       S            200A                                                    MD056262
     D PSysVal10       S             20A                                                    MD056262
     D PCurSet10       S            200A                                                    MD056262

      *****************************************************************
      /EJECT
      *****************************************************************

     ICGUXMLD0      01
     I                                          XMITEM        L1                Item Identifier

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

      ** Concatenate tags and data

      ** Update Message Header for Meridian

     C                   SELECT
     C                   WHEN      XMTAGN = '<SEStatementHolding>'
     C                   EVAL      WkData = '<MeridianMessage MessageType= +
     C                                      "SEStatementHolding">'

     C                   WHEN      XMTAGN = '<SEStatementTransaction>'
     C                   EVAL      WkData = '<MeridianMessage MessageType= +
     C                                      "SEStatementTransaction">'

     C                   WHEN      XMTAGN = '<SEStatementPending>'                            CSE040
     C                   EVAL      WkData = '<MeridianMessage MessageType= +                  CSE040
     C                                      "SEStatementPending">'                            CSE040
      ** Update Message Trailer for Meridian

     C                   WHEN      XMTAGN = '</SEStatementHolding>'
     C                   EVAL      WkData = '</MeridianMessage>'

     C                   WHEN      XMTAGN = '</SEStatementTransaction>'
     C                   EVAL      WkData = '</MeridianMessage>'

     C                   WHEN      XMTAGN = '</SEStatementPending>'                           CSE040
     C                   EVAL      WkData = '</MeridianMessage>'                              CSE040
                                                                                              CSE040
     C                   OTHER

      ** Convert Invalid Characters

     C     InvChr:RepChr XLATE     XMTAGV        WkTagValue

      ** Update Message Detail for Meridian

     C                   EVAL      WkData = %TRIM(XMTAGN)                       Tag Name
     C                                    + %TRIM(WkTagValue)                   Tag Value
     C                                    + %TRIM(XMENDT)                       End Tag
     C                   ENDSL

      ** Add details to audit file

     C                   EVAL      SNDATA = WkData
     C                   WRITE     SES2MMD0

      ** Check if the maximum length will be reached

     C                   EVAL      WkLenData = %LEN(%TRIM(WkData))

     C                   IF        CSW038 = 'N'                                             MD056262
      *                                                                                     MD056262
     C                   IF        WkLenMsg + WkLenData > MaxLength

      ** If maximum lenght reached, send the current message data

     C                   EXSR      $SndMsg

     C                   ENDIF
     C                   ENDIF                                                              MD056262

      ** Add the extracted data to current message data

     C                   EVAL      %SUBST(WkMsgDta:WkLenMsg+1) =
     C                             WkData
     C                   EVAL      WkLenMsg = WkLenMsg + WkLenData

      ** If new message, send the current message data

     CL1                 IF        CSW038 = 'Y'                                             MD056262
     CL1                 EXSR      SR_MQOut                                                 MD056262
     CL1                 ELSE                                                               MD056262
     CL1                 EXSR      $SndMsg
     CL1                 ENDIF                                                              MD056262

     CLR                 IF        CSW038 = 'Y'                                             MD056262
     CLR                 EXSR      SR_Close                                                 MD056262
     CLR                 ENDIF                                                              MD056262
     CLR                 RETURN

      **********************************************************************
      /EJECT
      *****************************************************************
      * $SndMsg - Send message to Data Queue                          *
      *****************************************************************

     C     $SndMsg       BEGSR
      *    -------       -----

     C                   IF        WkMsgDta <> *Blanks                                        221616

     C                   CALL      'QSNDDTAQ'
     C                   PARM                    SDDTAQ                         Data Queue
     C                   PARM                    SDLIB                          Library
     C                   PARM                    MaxLength                      Message Length
     C                   PARM                    WkMsgDta                       Message Data

     C                   ENDIF                                                                221616

      ** Clear Message Data

     C                   EVAL      WkMsgDta = *BLANKS                           Message Data
     C                   EVAL      WkLenMsg = *ZEROS                            Message Length

      *                  -----
     C                   ENDSR

      **********************************************************************                MD056262
      /EJECT                                                                                MD056262
      **********************************************************************                MD056262
      *                                                                    *                MD056262
      * SR_Open        : Open MQ series queue                              *                MD056262
      *                                                                    *                MD056262
      * Called by      : *INZSR                                            *                MD056262
      *                                                                    *                MD056262
      * Calls          : QMQM                                              *                MD056262
      *                                                                    *                MD056262
      **********************************************************************                MD056262
      *                                                                                     MD056262
     C     SR_Open       BEGSR                                                              MD056262
      *                                                                                     MD056262
      ** Connect to the queue manager                                                       MD056262
      *                                                                                     MD056262
     C**********         CALLP     MQCONN( ODMN : HCONN :                          MD056262 MD058195
     C**********                           OCODE  : REASON )                       MD056262 MD058195
     C                   CALL      'MQCONN'                                                 MD058195
     C                   PARM                    ODMN                                       MD058195
     C                   PARM                    HCONN                                      MD058195
     C                   PARM                    OCODE                                      MD058195
     C                   PARM                    REASON                                     MD058195
      *                                                                                     MD056262
      ** If connect failed, indicate abnormal end                                           MD056262
      *                                                                                     MD056262
     C     REASON        IFNE      RCNONE                                                   MD056262
     C                   EXSR      *PSSR                                                    MD056262
     C                   ENDIF                                                              MD056262
      *                                                                                     MD056262
      ** Open queue for OUTPUT                                                              MD056262
      *                                                                                     MD056262
     C     OOOUT         ADD       OOFIQ         OPTS                                       MD056262
      *                                                                                     MD056262
     C**********         CALLP     MQOPEN( HCONN : MQOD : OPTS :                   MD056262 MD058195
     C**********                           HIN : OCODE : REASON )                  MD056262 MD058195
     C                   CALL      'MQOPEN'                                                 MD058195
     C                   PARM                    HCONN                                      MD058195
     C                   PARM                    MQOD                                       MD058195
     C                   PARM                    OPTS                                       MD058195
     C                   PARM                    HIN                                        MD058195
     C                   PARM                    OCODE                                      MD058195
     C                   PARM                    REASON                                     MD058195
      *                                                                                     MD056262
      ** If open queue failed, indicate abnormal end                                        MD056262
      *                                                                                     MD056262
     C     REASON        IFNE      RCNONE                                                   MD056262
     C                   EXSR      *PSSR                                                    MD056262
     C                   ENDIF                                                              MD056262
      *                                                                                     MD056262
     C                   ENDSR                                                              MD056262
      **********************************************************************                MD056262
      /EJECT                                                                                MD056262
      **********************************************************************                MD056262
      *                                                                    *                MD056262
      * SR_Close       : Close MQ series queue                             *                MD056262
      *                                                                    *                MD056262
      * Called by      : MAIN                                              *                MD056262
      *                                                                    *                MD056262
      * Calls          : QMQM                                              *                MD056262
      *                                                                    *                MD056262
      **********************************************************************                MD056262
      *                                                                                     MD056262
     C     SR_Close      BEGSR                                                              MD056262
      *                                                                                     MD056262
      ** Close options: NONE                                                                MD056262
      *                                                                                     MD056262
     C                   Z-ADD     CONONE        OPTS                                       MD056262
      *                                                                                     MD056262
      ** Close queue                                                                        MD056262
      *                                                                                     MD056262
     C**********         CALLP     MQCLOSE( HCONN : HIN : OPTS :                   MD056262 MD058195
     C**********                            CCODE : REASON )                       MD056262 MD058195
     C                   CALL      'MQCLOSE'                                                MD058195
     C                   PARM                    HCONN                                      MD058195
     C                   PARM                    HIN                                        MD058195
     C                   PARM                    OPTS                                       MD058195
     C                   PARM                    CCODE                                      MD058195
     C                   PARM                    REASON                                     MD058195
      *                                                                                     MD056262
      ** If close queue failed, indicate abnormal end                                       MD056262
      *                                                                                     MD056262
     C     REASON        IFNE      RCNONE                                                   MD056262
     C                   EXSR      *PSSR                                                    MD056262
     C                   ENDIF                                                              MD056262
      *                                                                                     MD056262
      ** Close connection                                                                   MD056262
      *                                                                                     MD056262
     C**********         CALLP     MQDISC( HCONN : OCODE : REASON )                MD056262 MD058195
     C                   CALL      'MQDISC'                                                 MD058195
     C                   PARM                    HCONN                                      MD058195
     C                   PARM                    OCODE                                      MD058195
     C                   PARM                    REASON                                     MD058195
      *                                                                                     MD056262
      ** If disconnect failed, indicate abnormal end                                        MD056262
      *                                                                                     MD056262
     C     REASON        IFNE      RCNONE                                                   MD056262
     C                   EXSR      *PSSR                                                    MD056262
     C                   ENDIF                                                              MD056262
      *                                                                                     MD056262
     C                   ENDSR                                                              MD056262
      **********************************************************************                MD056262
      /EJECT                                                                                MD056262
      **********************************************************************                MD056262
      *                                                                    *                MD056262
      * SR_MQout       : Format and transmit TRAM Feedback to MQ Queue     *                MD056262
      *                                                                    *                MD056262
      * Called by      : Mainline                                          *                MD056262
      *                                                                    *                MD056262
      * Calls          : QMQM                                              *                MD056262
      *                                                                    *                MD056262
      **********************************************************************                MD056262
      *                                                                                     MD056262
     C     SR_MQout      BEGSR                                                              MD056262
      *                                                                                     MD056262
      ** Get message data                                                                   MD056262
      *                                                                                     MD056262
     C                   EVAL      P@MsgBuf = WkMsgDta                                      MD056262
      *                                                                                     MD056262
      ** Get message length                                                                 MD056262
      *                                                                                     MD056262
     C     w@null        SCAN      P@MsgBuf      P@MsgLen                 99                MD056262
     C     *in99         IFEQ      *off                                                     MD056262
     C                   Z-ADD     32000         P@MsgLen                                   MD056262
     c                   ENDIF                                                              MD056262
      *                                                                                     MD056262
      ** Remove null byte                                                                   MD056262
      *                                                                                     MD056262
     C     w@null:' '    XLATE     P@MsgBuf      P@MsgBuf                                   MD056262
      *                                                                                     MD056262
      ** MDFMT (Format Name) is a subfield of the MQMD data structure,                      MD056262
      ** defined in the include member CMQMDR.                                              MD056262
      ** FMSTR is a named constant defined in CMQR; it contains 'MQSTR   '.                 MD056262
      *                                                                                     MD056262
     C                   EVAL      MDFMT = FMSTR                                            MD056262
      *                                                                                     MD056262
      ** Send message to queue                                                              MD056262
      *                                                                                     MD056262
     C**********         CALLP     MQPUT( HCONN : HIN : MQMD : MQPMO :             MD056262 MD058195
     C**********                          P@MsgLen : %ADDR(P@MsgBuf) :             MD056262 MD058195
     C**********                          CCODE : REASON )                         MD056262 MD058195
     C                   IF        P@MsgBuf <> *BLANKS                                      MD058195
      *                                                                                     MD058195
     C                   CALL      'MQPUT'                                                  MD058195
     C                   PARM                    HCONN                                      MD058195
     C                   PARM                    HIN                                        MD058195
     C                   PARM                    MQMD                                       MD058195
     C                   PARM                    MQPMO                                      MD058195
     C                   PARM                    P@MsgLen                                   MD058195
     C                   PARM                    P@MsgBuf                                   MD058195
     C                   PARM                    CCODE                                      MD058195
     C                   PARM                    REASON                                     MD058195
      *                                                                                     MD056262
     C     REASON        IFNE      RCNONE                                                   MD056262
     C     REASON        ANDNE     RC2033                                                   MD056262
     C                   EXSR      *PSSR                                                    MD056262
     C                   ENDIF                                                              MD056262
      *                                                                                     MD058195
     C                   ENDIF                                                              MD058195
      *                                                                                     MD056262
      ** Clear message data                                                                 MD056262
      *                                                                                     MD056262
     C                   EVAL      WkMsgDta = *BLANKS                                       MD056262
     C                   EVAL      WkLenMsg = *ZEROS                                        MD056262
     C                   EVAL      P@MsgBuf = *BLANKS                                       MD056262
      *                                                                                     MD056262
     C                   ENDSR                                                              MD056262
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

      ** Read in Installation Data for Securities Statement
      *
     C     1             CHAIN     SDSESTPD
      *
     C                   IF        NOT %FOUND(SDSESTPD)
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDSESTPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  PSProcName
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                     MD056262
      ** Check if CSW038 feature is enabled for MQseries                                    MD056262
      *                                                                                     MD056262
     C                   CALL      'AOSARDR0'                                               MD056262
     C                   PARM      *BLANKS       @RTCD                                      MD056262
     C                   PARM      '*VERIFY'     @OPTN                                      MD056262
     C                   PARM      'CSW038'      @SARD                                      MD056262
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD056262
     C     @RTCD         IFEQ      *BLANKS                                                  MD056262
     C                   MOVE      'Y'           CSW038            1                        MD056262
     C                   ELSE                                                               MD056262
     C                   MOVE      'N'           CSW038                                     MD056262
     C                   ENDIF                                                              MD056262
      *                                                                                     MD056262
      ** Get system values                                                                  MD056262
      *                                                                                     MD056262
     C                   IF        CSW038 = 'Y'                                             MD056262
                                                                                            MD056262
     C                   CALLB     'AOSVALR0'                                               MD056262
     C                   PARM      *BLANKS       PRtCd                                      MD056262
     C                   PARM                    PSysVal01                                  MD056262
     C                   PARM                    PCurSet01                                  MD056262
     C                   PARM                    PSysVal02                                  MD056262
     C                   PARM                    PCurSet02                                  MD056262
     C                   PARM                    PSysVal03                                  MD056262
     C                   PARM                    PCurSet03                                  MD056262
     C                   PARM                    PSysVal04                                  MD056262
     C                   PARM                    PCurSet04                                  MD056262
     C                   PARM                    PSysVal05                                  MD056262
     C                   PARM                    PCurSet05                                  MD056262
     C                   PARM                    PSysVal06                                  MD056262
     C                   PARM                    PCurSet06                                  MD056262
     C                   PARM                    PSysVal07                                  MD056262
     C                   PARM                    PCurSet07                                  MD056262
     C                   PARM                    PSysVal08                                  MD056262
     C                   PARM                    PCurSet08                                  MD056262
     C                   PARM                    PSysVal09                                  MD056262
     C                   PARM                    PCurSet09                                  MD056262
     C                   PARM                    PSysVal10                                  MD056262
     C                   PARM                    PCurSet10                                  MD056262
      *                                                                                     MD056262
     C                   EVAL      ODMN = *BLANKS                                           MD056262
     C                   EVAL      ODON = *BLANKS                                           MD056262
      *                                                                                     MD056262
     C                   IF        PRtCd = *BLANKS                                          MD056262
     C                   EVAL      ODMN = PCurSet01                                         MD056262
     C                   EVAL      ODON = PCurSet02                                         MD056262
     C                   ELSE                                                               MD056262
      *                                                                                     MD056262
     C                   IF        PRtCd <> '*NRF'                                          MD056262
     C     *LOCK         IN        LDA                                                      MD056262
     C                   EVAL      DBFile = 'SDSVALPD'                                      MD056262
     C                   EVAL      DBase = 002                                              MD056262
     C                   EVAL      DBKey = PSysVal01                                        MD056262
     C                   OUT       LDA                                                      MD056262
     C                   EXSR      *PSSR                                                    MD056262
     C                   ENDIF                                                              MD056262
     C                   ENDIF                                                              MD056262
      *                                                                                     MD056262
      ** Open MQ series queue                                                               MD056262
      *                                                                                     MD056262
     C                   EXSR      SR_Open                                                  MD056262
     C                   ENDIF                                                              MD056262

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2003
