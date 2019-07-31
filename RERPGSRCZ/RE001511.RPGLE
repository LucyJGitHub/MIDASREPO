     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE ABC Data Queue Recovery')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE001511 - Account Balance Check Data Queue Recovery         *
      *                                                               *
      *  Function:  This program will write exception messages in     *
      *             ABC Exception Errors file Or; Resends exception   *
      *             messages from the exceptions file back into       *
      *             CREABCQ data queue depending on mode of run.      *
      *                                                               *
      *  Called By: REC001501 - Account Balance Check Update job      *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1089591 *CREATE  Date 05Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1089591 - ABC Data Queue Recovery Process                  *
      *              (Child:AR1089593)                                *
      *            - Applied for MD019899                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99         Error Indicator                                 *
      *    60         End-of-File Indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  Main routine                                                 *
      *  *INZSR         - Initialise                                  *
      *  *PSSR          - Error handling subroutine                   *
      *  SendMsg        - Resend Message Details to Data Queue        *
      *  ExMsgWrite     - Write exception message details on REABCXPD *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas RE ABC Message Details for Exception Errors
     FREABCXPD  O    E             DISK    INFSR(*PSSR)
 
      ** Midas RE ABC Message Details for Exception Errors (Logical)
     FREABCXL0  UF   E           K DISK    INFSR(*PSSR) PREFIX(X)
     F                                     RENAME(REABCXD0:REABCXUP)
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short data structure for access objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** The Following /COPY Line Includes All The Defined Fields In
      ** The PSDS.  They Have Meaningful Names, Prefixed By 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Arrays AND Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Local data area for database error details
     D LDA             DS           256
 
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBTXT                184    256
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Mode            S             10A
     D ZonPfx          S              2A
     D JobDet          S             28A
     D Message         S           4021A
 
     D DtaQName        S             10A
     D DtaQLib         S             10A
     D DtaQLen         S              5  0
     D DtaMsg          S           4021A
 
     D WRun            S              1A
     D PRtCd           S              7A
     D POptn           S              7A
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  MAIN - Processing                                            *
      *****************************************************************
 
     C                   SELECT
 
     C                   WHEN      Mode = 'ExMsgWrite'
     C                   EXSR      ExMsgWrite
 
     C                   WHEN      Mode = 'SendMsg'
     C                   EXSR      SendMsg
 
     C                   ENDSL
 
      ** Terminate program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ExMsgWrite - Write exception message details into REABCXPD    *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     ExMsgWrite    BEGSR
 
     C                   EVAL      MXLDAT = BJRDNB
     C                   EVAL      MXFLAG = 'F'
     C                   EVAL      MXJOB  = JobDet
     C                   EVAL      MXMSG = Message
 
     C                   WRITE     REABCXD0
 
     C     ExMsgWriteE   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SendMsg - Resend Message Details to Data Queue - CREABCQ      *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SendMsg       BEGSR
 
     C                   EVAL      DtaQName = 'CREABCQ'
     C                   EVAL      DtaQLib = ZonPfx + 'DPLIB'
     C                   READ      REABCXUP                               60
 
     C                   DOW       *IN60 <> '1'
 
     C                   EVAL      DtaMsg = ''
     C                   EVAL      DtaMsg = %TRIM( XMXMSG )
     C                   EVAL      DtaQLen = %LEN(%TRIM( DtaMsg ))
 
     C                   CALL      'QSNDDTAQ'
     C                   PARM                    DtaQName
     C                   PARM                    DtaQLib
     C                   PARM                    DtaQLen
     C                   PARM                    DtaMsg
 
     C                   EVAL      XMXFLAG = 'S'
     C                   UPDATE    REABCXUP
 
     C                   READ      REABCXUP                               60
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    Mode
     C                   PARM                    ZonPfx
     C                   PARM                    JobDet
     C                   PARM                    Message
 
      ** Read in data area
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  = 'RE001511'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBTXT  = *BLANKS
     C                   EVAL      DBASE  = 0
     C                   OUT       LDA
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     PRtcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBPGM  =  'AOBANKR0'
     C                   EVAL      DBASE  =  1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
 
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   ROLBK
     C                   RETURN
 
     C                   ENDSR
 
