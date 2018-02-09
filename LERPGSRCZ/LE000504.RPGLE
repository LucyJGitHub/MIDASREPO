     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Resend XML Transactions in Resend Status')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000504 - Midas LE Resend XML Transactions                  *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD022807F          Date 18Oct13               *
      *                 MD022807E *CREATE  Date 17Oct13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD022807F - Set LGSTAT as 'X' upon three (3) retries         *
      *  MD022807E - Resend XML Transactions Tagged as 'R'            *
      *                                                               *
      *****************************************************************
     FLEMQLGLD  UF   E           K DISK    INFSR(*PSSR)
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
      ** +--------------------------------------+
      **   Manually included D-specs            +
      **   =========================            +
      ** +--------------------------------------+
     D PWipQueue       S             48A
     D PRetCode        S              7A
     D PErrMsg         S             30A
     D PRequest        S             10A
     D PQueueNm        S             48A
     D PMQMgr          S             48A
     D PMsgBuf         S          32000A
     D WkRespQ         S             20A
     D WkMQMgr         S             48A
     D WkUser          S             10A
     D P@Key           S              4A
 
      ** System Value Parameter
     D POP01           S             20A
     D PVL01           S            200A
     D POP02           S             20A
     D PVL02           S            200A
     D POP03           S             20A
     D PVL03           S            200A
     D POP04           S             20A
     D PVL04           S            200A
     D POP05           S             20A
     D PVL05           S            200A
     D POP06           S             20A
     D PVL06           S            200A
     D POP07           S             20A
     D PVL07           S            200A
     D POP08           S             20A
     D PVL08           S            200A
     D POP09           S             20A
     D PVL09           S            200A
     D POP10           S             20A
     D PVL10           S            200A
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Read all records in LEMQLGPD whose status is 'R'
      *
     C                   EVAL      *IN50 = *OFF
     C     *IN50         DOWEQ     *OFF
     C                   READ      LEMQLGPF                               50
      *
     C     *IN50         IFEQ      *OFF
      *
      ** Resend XML data
      *
     C                   IF        ProgramName = LGPGNM
     C                   EXSR      SrSendXML
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSendXML - Send XML Transaction to Message Queue             *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: GPMQMIO                                                *
      *                                                               *
      *****************************************************************
     C     SrSendXML     BEGSR
      *
      ** Send message to MQ series queue
      *
     C                   EVAL      PRequest = '*OPEN_PUT'
     C                   EXSR      SRPutMQIO
      *
     C                   EVAL      PRequest = '*PUT'
     C                   EXSR      SRPutMQIO
      *
     C                   EVAL      PRequest = '*CLOSE'
     C                   EXSR      SRPutMQIO
      *
     C                   SELECT
     C                   WHEN      Action = 'Send  '
     C                   EVAL      LGSTAT = 'S'
     C                   WHEN      Action = 'Update'
     C                   EVAL      LGSTAT = 'X'
     C                   ENDSL
      *
     C                   UPDATE    LEMQLGPF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPutMQIO - Put message to MQ Series queue                   *
      *                                                               *
      * Called by: SRPDCLIN, SRPDCLIN                                 *
      *                                                               *
      * Calls: GPMQMIO                                                *
      *                                                               *
      *****************************************************************
     C     SRPutMQIO     BEGSR
      *
     C                   CALL      'GPMQMIO'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    PErrMsg
     C                   PARM                    PRequest
     C                   PARM      PWIPQueue     PQueueNm
     C                   PARM      LGXMLF        PMsgBuf
     C                   PARM                    P@Key
     C                   PARM      WkMQMgr       PMQMgr
      *
     C                   IF        (PRetCode <> *BLANKS) OR
     C                             (PErrMsg <> *BLANKS)
     C                   EXSR      *PSSR
     C                   ENDIF
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
      *
     C     *ENTRY        PLIST
     C                   PARM                    ProgramName      10
     C                   PARM                    Action            6
      *
     C                   EVAL      POP01 = 'MQTransSdrQueueCOB'
     C                   EVAL      POP02 = 'MQJMSRespQueueCOB'
     C                   EVAL      POP03 = 'MQQueueMgrCOB'
     C                   EVAL      POP04 = 'MQPDPUserIDCOB'
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    POP01
     C                   PARM      *BLANKS       PVL01
     C                   PARM                    POP02
     C                   PARM      *BLANKS       PVL02
     C                   PARM                    POP03
     C                   PARM      *BLANKS       PVL03
     C                   PARM                    POP04
     C                   PARM      *BLANKS       PVL04
     C                   PARM                    POP05
     C                   PARM      *BLANKS       PVL05
     C                   PARM      *BLANKS       POP06
     C                   PARM      *BLANKS       PVL06
     C                   PARM      *BLANKS       POP07
     C                   PARM      *BLANKS       PVL07
     C                   PARM      *BLANKS       POP08
     C                   PARM      *BLANKS       PVL08
     C                   PARM      *BLANKS       POP09
     C                   PARM      *BLANKS       PVL09
     C                   PARM      *BLANKS       POP10
     C                   PARM      *BLANKS       PVL10
      *
     C                   IF        PRetCode <>  *BLANKS
     C                   MOVEL     'SDSVALPD'    DBFILE
     C                   Z-ADD     1             DBASE                U7U8
     C                   MOVEL     POP01         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      PWIPQueue = PVL01
     C                   EVAL      WkRespQ   = PVL02
     C                   EVAL      WkMQMgr   = PVL03
     C                   EVAL      WkUser    = %TRIM(PVL04)
      *
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
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2013
