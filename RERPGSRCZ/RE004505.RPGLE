     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cashier TCP/IP branch monitor status ctl')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE004505 - Midas Cashier TCP/IP Branch Monitor Status Control*
      *                                                               *
      *  This program is based on RE4405 and both version should be   *
      *  maintained at the same level.                                *
      *                                                               *
      *  Function:  This program will be evoked automatically during  *
      *  (I/C)      Input Cycle by each remote Branch Monitor Status  *
      *             job starting at the AS/400. It will provide the   *
      *             information pertaining to the change in status of *
      *             the Branch Monitior's link between the Midas      *
      *             system on the AS/400 and the remote branch monitor*
      *             by opening a conversation with the requester.     *
      *             It will receive suspend, close down or resume     *
      *             status messages from the remote branch monitor.   *
      *  Author: Alain Differdange                                    *
      *  Called By: REC4505 - CI Branch Monitor Status Control        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *  Last Amend No. CRT004  *CREATE    Date 06JUN00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRT004 - Cashier Midas TCP/IP interface.                     *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *                  FUNCTION OF INDICATORS                       *
      *                  ----------------------                       *
      *                                                               *
      *                                                               *
      *       80-89      Standard RTS subroutines                     *
      *                                                               *
      *       90-99      Standard MIDAS subroutines                   *
      *                                                               *
      *                                                               *
      *       U6         System error                                 *
      *       U7+U8      Database error occurs                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  TCPERR - TCP/IP Functions Error Handling.                    *
      *  DBERR  - Database Error Handling.                            *
      *  INIT   - Initialisation.                                     *
      *  *PSSR  - Program Error.                                      *
      *                                                               *
      *  ZDATE2 - Convert Midas dayno to a date format                *
      *                                                               *
      *****************************************************************
      /EJECT
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      **  Array containing Copyright statement.
      *
     D PSDS           SDS
      **  Program status data structure.
      *
     D  ZAPGM            *PROC
     D  WSID                 244    246
     D  WSID2                245    246
     D  WSJOB                244    253
     D  USRID                254    263
     D  JNUMBR               264    269  0
     D  JOBNUM               264    269
      *
     D LDA             DS           256
      **  Local Data Area to identify database errors.
      *
     D  PBRCA                  1      3
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBLOT                134    183
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Bank Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Second DS for access programs, long data structure
      *
      **************************************************************************
      **  Socket Functions Prototype Definitions (Service Program SP670RE01)
      *
     D opn_tcp         pr            10i 0
 
     D bnd_tcp         pr            10i 0
     d                               10i 0 Const
     d                               10i 0 Const
     d                               10i 0 Const
 
     D con_tcp         pr            10i 0
     d                               10i 0 Const
     d                               30
     d                                2  0 Const
     d                                4  0 Const
     D sel_tcp         pr            10i 0
     d  socket                       10i 0
     d  time_sec                     10i 0
     d  wait_act                     10i 0
     d  rc                           10i 0
 
     D snd_tcp         pr            10i 0
     d                               10i 0 Const
     d                             9911
 
     D rcv_tcp         pr            10i 0
     d                               10i 0 Const
     d                             9911
 
     D cls_tcp         pr            10i 0
     d                               10i 0 Const
 
      **  Other variables
      *
     D ScktNum         S             10I 0
     D RetCode         S             10I 0
     D Sbuffer         S           9911
     D Rbuffer         S           9911
     D Risc            S             30
     d time_sec        S             10i 0
     d wait_act        S             10i 0
     d rc              S             10i 0
 
     d brca            S              3
     d usid            S             10
     d prfx            S              2
     D clsdwn          S              9
     D wmdta1          S             10
     D wmdta2          S             10
      *
     D RE4505IC        DS
      **  Structure for TCP/IP Error Messages
      *
     D  HEADER                 1     11
     D  RQSTAT                12     15
     D  RQHMSS                16     16
     D  RQHMSI                17     20
     D  RQHSMS                21     98
      *****************************************************************
      *
     C                   EXSR      INIT
      *
     C                   MOVEL     '1'           *INLR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            INIT   - Initial Processing.                       *
      *                                                               *
      * CALLS      ZDATE2 - Convert Midas dayno to a date format      *
      *            DBERR  - Database Error Handling                   *
      *            *PSSR  - Program Error.                            *
      *                                                               *
      * CALLED BY  MAIN   - Main Control Processing.                  *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
      **  Clear DB ERROR information in LDA.
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     *BLANK        DBLOT
     C                   OUT       LDA
      *
      **  Define Entry list
      *
     C     *entry        plist
     C                   parm                    ScktNum
     C                   parm                    brca
     C                   parm                    usid
     C                   parm                    prfx
      *
      **  Define Parmlist(s).
      **  Parameters for QSNDDTAQ (To Branch Trickle Feed).
      *
     C     DTQSND        PLIST
     C                   PARM                    DTAQS
     C                   PARM                    LIBS
     C                   PARM                    LENS
     C                   PARM                    DTAS
      *
     C                   MOVEA     CPY@          MKI@             80
      *
      **  Set the value of the Branch Trickle Feed data queue name.
      *
     C     'CASHTF_'     CAT       PBRCA         WTFBR            10
      *
      **  Set up parameters for Branch Trickle Feed data queue.
      *
     C                   MOVEL     WTFBR         DTAQS            10
     C                   MOVEL     '*LIBL'       LIBS             10
     C                   Z-ADD     29            LENS              5 0
      *
     C                   CALL      'SF0410'
     C                   PARM      *BLANKS       PGRP             50
     C                   PARM      USRID         PUSR             25
     C                   PARM      *ZEROS        PLVL              4 0
     C                   PARM      *ZEROS        PTIM              5 0
     C                   PARM      *ZEROS        PERR              1 0
     C                   PARM      *BLANKS       PMLT              2
      *
     C     PMLT          IFEQ      *BLANK
     C                   MOVEL     'GB'          PMLT
     C                   ENDIF
      *
     C     PMLT          CAT       'CIMSGF'      @MSGF            10
     C                   MOVEL     *BLANKS       PMSID             7
      *
      ** Test if no error from SF0410
      *
     C                   If        perr <> *zeros
     C                   movel     '00000087'    header
     C                   move      'E'           RQHMSS
     C                   move      'ERR'         header
     C                   clear                   Sbuffer
     C                   movel     re4505ic      Sbuffer
      * Send ERR message
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      * Close Socket and exit
     C                   eval      RetCode = Cls_Tcp( ScktNum )
     C                   exsr      dberr
      * Send MOK message (Reply to MOK received in listener)
     C                   Else
     C                   movel     '00000000'    header
     C                   move      'MOK'         header
     C                   clear                   Sbuffer
     C                   movel     header        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
     C                   EndIf
      *
      * Receive next message and map it to CLSDWN format
      *
     C                   Eval      RetCode = Rcv_Tcp( ScktNum: Rbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   Else
     C                   eval      clsdwn= %subst(Rbuffer :12)
     C                   EndIf
      *
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  If error on access to Bank Details.
      *
     C     @RTCD         IFNE      *BLANKS
      *
      **  Report error.
      *
     C                   MOVEL     'USR0051'     @MSGID
     C                   MOVEL     *BLANKS       WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
      *
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        RQHSMS
     C                   MOVE      'E'           RQHMSS
     C                   MOVE      @MSGID        RQHMSI
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4505'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      PBRCA         P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
     C                   movel     '00000087'    header
     C                   move      'ERR'         header
     C                   clear                   Sbuffer
     C                   movel     re4505ic      Sbuffer
      * Send ERR message
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      * Close Socket and exit
     C                   eval      RetCode = Cls_Tcp( ScktNum )
      *
      **  Set up LDA DBERR.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     1             DBASE
     C                   EXSR      DBERR
      *
     C                   ELSE
      *
      **  System run date.
      *
     C                   Z-ADD     BJRDNB        ZDAYNO
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      '0'           *IN98
     C                   ELSE
     C                   MOVE      '1'           *IN98
     C                   ENDIF
      *
     C                   Call      'ZDATE2'
     C                   Parm                    ZDAYNO            5 0
     C                   Parm                    ZDATFM            1
     C                   Parm                    ZDATE             6 0
     C                   Parm                    ZADATE            7
     C                   Z-ADD     ZDATE         WRDATE            6 0
      *
     C     'Close'       CAT       'Down'        WCLOSE            9
      *
      ** If 'CloseDown' (Upper & Lower case) Branch Monitor received from PC
      *
     C     CLSDWN        IFEQ      WCLOSE
     C                   MOVEL     'USR0070'     @MSGID
     C                   MOVEL     PBRCA         WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
      *
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        RQHSMS
     C                   MOVE      'C'           RQHMSS
     C                   MOVE      @MSGID        RQHMSI
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4505'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      PBRCA         P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
     C                   ENDIF
      *
      ** If 'SUSPEND' Branch Monitor received from PC.
      *
     C     CLSDWN        IFEQ      '*SUSP'
     C                   MOVEL     'USR0071'     @MSGID
     C                   MOVEL     PBRCA         WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
      *
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        RQHSMS
     C                   MOVE      'C'           RQHMSS
     C                   MOVE      @MSGID        RQHMSI
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4505'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      PBRCA         P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
     C                   ENDIF
      *
      ** If Branch Monitor has been resumed is received from PC.
      ** (A blank message is the instruction to resume)
      *
     C     CLSDWN        IFEQ      *BLANKS
     C                   MOVEL     'USR0072'     @MSGID
     C                   MOVEL     PBRCA         WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
      *
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        RQHSMS
     C                   MOVE      'C'           RQHMSS
     C                   MOVE      @MSGID        RQHMSI
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4505'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      PBRCA         P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
     C                   ENDIF
      *
     C     CLSDWN        IFEQ      '*SUSP'
      *
     C                   MOVEL     *BLANKS       DTAS             29
     C                   MOVEL     'SUSP'        DTAS
      *
     C                   CALL      'QSNDDTAQ'    DTQSND
      *
     C                   ENDIF
      *
     C                   MOVEL     'SUSP'        RQSTAT
      * Send ACK message
     C                   movel     '00000000'    header
     C                   move      'ACK'         header
     C                   clear                   Sbuffer
     C                   movel     header        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
      * Receive next message and map it to CLSDWN format: It should be DET
      *
     C                   Eval      RetCode = Rcv_Tcp( ScktNum: Rbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   Else
     C                   eval      clsdwn= %subst(Rbuffer :12)
     C                   EndIf
      *
      * Close Socket and exit
      *
     C                   eval      RetCode = Cls_Tcp( ScktNum )
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C*****************************************************************
      *                                                               *
      *            RTVMSG - Retrieve Message from Message File        *
      *                                                               *
      * CALLS     REC4160 - Retrive Message from Message File         *
      *                                                               *
      * CALLED BY  MOVDET - Move Details to Send to Outgoing DataQ    *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
      *
     C     RTVMSG        BEGSR
      *
     C                   CALL      'REC4160'
     C                   PARM                    @MSGID            7
     C                   PARM                    @MSGF            10
     C                   PARM                    @MSGDT          256
     C                   PARM      *BLANKS       @MSGTX           80
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
      *                                                               *
      *            TCPERR - Report Communication error                *
      *                                                               *
      * CALLS     REC4411 - Midas RE CI Comms Program Error Report    *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     TCPERR        BEGSR
      *
     C                   MOVEL     'USR0090'     @MSGID
     C                   MOVEL     *BLANKS       WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4505'      PROG             10
     C                   PARM                    JOBNUM            6
     C                   PARM      '0000'        MMCODE            4
     C                   PARM      PBRCA         P#BRCA            3
     C                   PARM                    @MSGID            7
     C                   PARM                    @MSGDT
      * Close Socket
     C                   Eval      RetCode = Cls_Tcp( ScktNum )
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'TCP COMM'    DBFILE
     C                   MOVEL     *BLANKS       DBKEY
     C                   Z-ADD     99            DBASE
      *
     C                   EXSR      DBERR
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            DBERR  - Database Error Handling.                  *
      *                                                               *
      * CALLS      *PSSR  - Program Error.                            *
      *                                                               *
      * CALLED BY  INIT   - Initial Processing.                       *
      *                                                               *
      *****************************************************************
     C     DBERR         BEGSR
      *
     C                   MOVEL     PROG          DBPGM
     C                   OUT       LDA
      *
     C                   EXSR      *PSSR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            *PSSR  - Program Error.                            *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY         -                                           *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
