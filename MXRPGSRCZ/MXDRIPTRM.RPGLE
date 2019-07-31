     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Drip-Feed Transmission')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXDRIPTRM - Drip-Feed Transmission                           *
      *                                                               *
      *  Function:  This module sends data via MQ Series to Meridian  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR869911           Date 18Apr13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG17937           Date 24Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244430             Date 05Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW039             Date 15Sep05               *
      *                 CSE040             Data 05Feb03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR869911 - Use the system value 'MQQueueManagerAPI' as the   *
      *             default queue manager for export                  *
      *           - Applied for MD019934                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17937 - SEC3300 is Failing with an error.  Applied fix    *
      *             245268                                            *
      *  244430 - Call RTVNODEREF if CSW038 is off.                   *
      *  CSW039 - Add System/Priority to Correlation ID               *
      *  CSE040 - Securities Statement Processing                     *
      *           Add CMX011 - Midas Export Using Data Queue          *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXEXFDL2  IF   E           K DISK    INFSR(*PSSR)
      * Meridian Export Format Details
 
     FMXCOMDPD  IF   E           K DISK    INFSR(*PSSR)
      * Composite Message Details
 
     FMXMQDLL2  IF   E           K DISK    INFSR(*PSSR)
      * Meridian Export MQ series data
 
     FMXOLTJPD  UF   E             DISK    COMMIT INFSR(*PSSR)
 
     FMXDRIPTAU O    E             PRINTER INFSR(*PSSR)  USROPN
      * Drip-Feed Transmission Audit Report
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
 
      * R E F O R M A T   D A T A
     D/COPY MXCPYSRC,MXRFMDD
 
     D                 DS
     D  p@msgbuf               1  32000
     D  a@msgbuf               1  32000
     D                                     DIM(32000)
 
 
     D JournalEnt      DS
      * Standard fields on all journal entries
     D  Filler01                      5A
     D  JrnSeqn                      10A
     D  JrnCode                       1A
     D  JrnEntType                    2A
     D  Filler02                     38A
     D  Program                      10A
     D  File_Name                    10A
     D  Library                      10A
     D  Member                       10A
     D  RelRecNum                    10A
     D  Filler03                     19A
      * Fields specific to the journal entry
     D  TGJRNS                       10A
     D  TGCOMI                        8A
 
     D ControlInf      DS
     D  CTRLInfo1                     1
     D  CTRLInfo2                     1
 
 
      * Composite Message Formats
     D MXCOMF        E DS                  EXTNAME(MXCOMFPD)
      * Transmission Header
     D MXTRMH        E DS                  EXTNAME(MXTRMHPD)
 
     D  sdstat       E DS                  extname(SDSTAT)                                    CSW039
 
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)
      ** Export Control Data
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  244430
      ** External DS for SAR details                                                          244430
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     DLibName          S             10
     DQName            S             10
     DTextLen          S              2  0
     DDataLen          S              5  0 INZ(32000)
     DDataString       S          32000
                                                                                            AR869911
      ** Access Object Parameters                                                           AR869911
     D PRetCode        S              7A                                                    AR869911
     D PSysValK1       S             20A                                                    AR869911
     D PSysVal1        S            200A                                                    AR869911
     D PSysValK2       S             20A                                                    AR869911
     D PSysVal2        S            200A                                                    AR869911
     D PSysValK3       S             20A                                                    AR869911
     D PSysVal3        S            200A                                                    AR869911
     D PSysValK4       S             20A                                                    AR869911
     D PSysVal4        S            200A                                                    AR869911
     D PSysValK5       S             20A                                                    AR869911
     D PSysVal5        S            200A                                                    AR869911
     D PSysValK6       S             20A                                                    AR869911
     D PSysVal6        S            200A                                                    AR869911
     D PSysValK7       S             20A                                                    AR869911
     D PSysVal7        S            200A                                                    AR869911
     D PSysValK8       S             20A                                                    AR869911
     D PSysVal8        S            200A                                                    AR869911
     D PSysValK9       S             20A                                                    AR869911
     D PSysVal9        S            200A                                                    AR869911
     D PSysValK10      S             20A                                                    AR869911
     D PSysVal10       S            200A                                                    AR869911
                                                                                            AR869911
      ** Named constants                                                                    AR869911
     D WConst          C                   'MQQueueManagerAPI'                              AR869911
 
 
     C     *ENTRY        PLIST
     C                   PARM                    JournalEnt
     C                   PARM                    ControlInf
 
 
      * If the first byte of Control Information is 0, no data has been
      *  passed so simply return
 
     C                   IF        CTRLInfo1 = '0'
     C                   RETURN
     C                   ENDIF
 
      * If 'stop' (XE) or 'pause' (XJ) requested,
      * Update the last journal sequence number processed on MXOLTJPD
      * and end this program
 
     C     JrnEntType    IFEQ      'XE'
     C     JrnEntType    OREQ      'XJ'
     C                   MOVEL     TGJRNS        CTRL_TXT          3
     C     CTRL_TXT      IFEQ      'TRM'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      UPD_MXOLTJ
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      * Reset the message buffer and end of message pointer
 
     C                   clear                   p@msgbuf
     C                   z-add     1             eoMp              6 0
 
      * Update the time
 
     C                   TIME                    #TIME
 
      * Read a record for the journal sequence number
 
     C     MXMQDLK       SETLL     MXMQDLP0
     C     MXMQDLK       READE     MXMQDLP0                               50    *
 
     C     *IN50         DOWEQ     '0'
 
      * Do initialization
 
     C     eoMp          IFEQ      1
     C                   EXSR      INIT
     C                   ENDIF
 
      * Set up outbound data and end position of this data
 
     C     MQEPOS        SUB       1             OutPos
     C                   Eval      OutData = MQMDTL
 
      * Add outbound data to the reference buffer
 
     C                   movea     OutData       a@msgbuf(eoMp)
     C                   add       OutPos        eoMp
 
      * Error if 32000 byte limit exceeded
 
     C     eoMp          IFGT      32000
     C                   EXSR      UPD_MXOLTJ
     C                   EVAL      I#ERMS = 'MESSAGE LIMIT EXCEEDED'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If a message is present
      * and the composite ID is *NONE (i.e. this is a single file format)
      * 'Put' the message to the MQ Series queue
 
     C     eoMp          ifgt      TRMH_Eps
     C     TRMH_Eps      andne     *ZERO
     C     MQCOMI        andeq     '*NONE   '
     C                   EXSR      PUT_MSG
     C                   endif
 
      * Read a record for the journal sequence number
 
     C     MXMQDLK       READE     MXMQDLP0                               50    *
     C                   ENDDO
 
      * If a message is present
      * 'Put' the message to the MQ Series queue
 
     C     eoMp          ifgt      TRMH_Eps
     C     TRMH_Eps      andne     *ZERO
     C                   EXSR      PUT_MSG
     C                   endif
 
 
      *  Update the last journal sequence number processed on MXOLTJPD
 
     C                   EXSR      UPD_MXOLTJ
 
      * 'Normal' return
 
     C                   RETURN
 
      *******************************************************************
      /SPACE 5
      *********************************************************************
      * Access single format details
      *********************************************************************
     C     ACS_FMT       BEGSR
 
     C     MQFMT         CHAIN     MXEXFDP0                           99        *
     C     *in99         IFEQ      '1'
     C                   EXSR      UPD_MXOLTJ
     C                   EVAL      I#ERMS = 'MISSING FORMAT:'
     C                             + MQFMT
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * INITIALIZE:
      * Description
      * Message Queue Name
      ** MQQueueManagerAPI                                                                  AR869911
 
     C                   MOVEL     EXFMT         CDMSGT
     C                   MOVEL     EXMSGQ        CDMSGQ
     C                   EVAL      CDQMGR = %TRIM(PSysVal1)                                 AR869911
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      *********************************************************************
      * Access composite details
      *********************************************************************
     C     ACS_COM       BEGSR
 
     C     MXCOMDK       CHAIN     MXCOMDP0                           99        *
     C     *in99         IFEQ      '1'
     C                   EXSR      UPD_MXOLTJ
     C                   EVAL      I#ERMS = 'MISSING COMPOSITE:'
     C                             + MQCOMI + MQEXTT
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                            AR869911
      ** MQQueueManagerAPI                                                                  AR869911
                                                                                            AR869911
     C                   IF        CDQMGR = *BLANKS                                         AR869911
     C                   EVAL      CDQMGR = %TRIM(PSysVal1)                                 AR869911
     C                   ENDIF                                                              AR869911
 
     C                   ENDSR
     C********************************************************************
     C/SPACE 5
      ********************************************************************
      * Initial processing
      ********************************************************************
     C     INIT          begsr
 
      * Access single format details or access composite details
 
     C     MQCOMI        IFEQ      '*NONE   '
     C                   EXSR      ACS_FMT
     C                   ELSE
     C                   EXSR      ACS_COM
     C                   ENDIF
 
      ** Set Up Transmission Header
 
     C                   MOVEL     CDMSGT        APTGTTYPE
     C                   Z-ADD     1             APCOMMC
     C                   EVAL      APTGTSYS = 'MidasExp'
     C                   EVAL      APSRCSYS = 'MidasExp'
 
     C                   CALLB     'MXFMTDATA'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
     C                   PARM      *BLANK        W#MODE            1
     C                   PARM      '*NONE   '    W#COMI            8
     C                   PARM      *BLANK        W#EXTT            1
     C                   PARM      *BLANK        W#SEQM            2
     C                   PARM      'MXTRMHPD  '  W#FMT            10
     C                   PARM      MXTRMH        InData         4000
      * OUTPUT
      * Composite Message Format
     C                   PARM                    MXCOMF
      * Out Position
      * Outbound Data
     C                   PARM                    OutPos
     C                   PARM                    MXTRMH_O       4000
      * Reference ID
      * Select For Export
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXFMTDATA'
     C                   EXSR      *PSSR
     C                   ENDIF
 
 
      * Set end position of transmission header
      * and length of transmission header
 
     C                   z-add     OutPos        TRMH_Eps          4 0
     C     OutPos        sub       1             TRMH_Len          4 0
 
      * Add transmission header to message buffer
 
     C                   movea     MXTRMH_O      a@msgbuf(eoMp)
     C                   add       TRMH_Len      eoMp
 
     C                   endsr
      *********************************************************************
     C/SPACE 5
      ********************************************************************
      * 'Put' the message to the MQ Series queue
      ********************************************************************
     C     PUT_MSG       begsr
 
      *   Close the MQ Series queue (if previously opened)
      *   then open the MQ Series queue for 'put'
 
     C     CDMSGQ        ifne      p@queuenm
 
      ** If a MQ serie was used in the previous message, close the previous MQ queue.         CSE040
                                                                                              CSE040
     C*****p@queuenm     ifne      *BLANK                                                     CSE040
     C                   if        p@queuenm <> *BLANKS                                       CSE040
     C                             AND  %SUBST(p@queuenm:1:5) <> 'DTAQ/'                      CSE040
     C                   movel     '*CLOSE    '  p@request
     C                   exsr      sr_MQM
     C                   endif
 
      ** If a MQ serie is used to send the message, open the MQ queue.                        CSE040
                                                                                              CSE040
     C                   if        %SUBST(CDMSGQ:1:5) <> 'DTAQ/'                              CSE040
                                                                                              CSE040
     C                   movel     '*OPEN_PUT '  p@request
     C                   exsr      sr_MQM
                                                                                              CSE040
     C                   else                                                                 CSE040
                                                                                              CSE040
      * Set up library and data queue name                                                    CSE040
                                                                                              CSE040
     C                   eval      LibName = *BLANKS                                          CSE040
     C                   eval      QName   = *BLANKS                                          CSE040
     C                   eval      TextLen = %SCAN('/':CDMSGQ:6)                              CSE040
     C                   if        TextLen > 6                                                CSE040
     C                   eval      LibName = %SUBST(CDMSGQ:6:TextLen-6)                       CSE040
     C                   endif                                                                CSE040
     C                   eval      QName=%SUBST(CDMSGQ:TextLen+1:10)                          CSE040
                                                                                              CSE040
     C                   endif                                                                CSE040
     C                   endif
 
     C                   if        %SUBST(CDMSGQ:1:5) <> 'DTAQ/'                              CSE040
                                                                                              CSE040
      * 'Put' the message
 
     C                   movel     '*PUT      '  p@request
     C                   exsr      sr_MQM
 
     C                   else                                                                 CSE040
                                                                                              CSE040
      * Output the message in data queue                                                      CSE040
                                                                                              CSE040
     C                   If        CMX011 = 'Y'                                               CSE040
                                                                                              CSE040
     C                   CALL      'QSNDDTAQ'                                                 CSE040
     C                   PARM                    Qname                                        CSE040
     C                   PARM                    LibName                                      CSE040
     C                   PARM                    DataLen                                      CSE040
     C                   PARM      p@msgbuf      DataString                                   CSE040
                                                                                              CSE040
     C                   endif                                                                CSE040
                                                                                              CSE040
     C                   eval      p@queuenm = CDMSGQ                                         CSE040
                                                                                              CSE040
     C                   endif                                                                CSE040
 
      * If the trace is ON
      * Report the message transmitted
 
     C     TRACDT        IFEQ      'Y'
     C                   EXSR      RPT_MSGT
     C                   endif
 
      * Reset the message buffer and end of message pointer
 
     C                   clear                   p@msgbuf
     C                   z-add     1             eoMp              6 0
 
     C                   endsr
     C*********************************************************************
     C/SPACE 5
      ********************************************************************
      * Do MQ Series Queue Operations
      *********************************************************************
     C     sr_MQM        begsr
 
     C                   CALLB     'MXMQMIO'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      * Request
      ** Queue Manager                                                                      BUG17937
      * Queue Name
      * Message Buffer
     C                   parm                    p@request        10
     C                   parm      CDQMGR        p@qmnager        48                        BUG17937
     C                   parm      CDMSGQ        p@queuenm        48
     C                   parm                    p@msgbuf      32000
     C**********         parm                    p@key             4                   CSW039 244430
     C                   parm                    p@key             2                          244430
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXMQMIO'
     C                   EXSR      *PSSR
     C                   endif
 
     C                   endsr
      *********************************************************************
     C/SPACE 5
      ********************************************************************
      * Report the message transmitted
      ********************************************************************
     C     RPT_MSGT      BEGSR
 
      * Output message to report in 100 byte chunks
 
     C                   z-add     1             ctr               6 0
 
     C     ctr           DOUGT     eoMp
 
     C                   movel     *BLANK        MSGDTA          100
     C                   movea     a@msgbuf(ctr) MSGDTA
     C                   add       100           ctr
 
     C     ctr           sub       1             prt_epos          6 0
 
     C                   Z-ADD     1             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     MSG
 
     C                   ENDDO
 
      * Output end of message line
 
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   WRITE     ENDOFMSG
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Throw page headings (if required)
      ********************************************************************
     C     PAG           BEGSR
 
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM
     C                   WRITE     PAGEHEAD
     C     4             ADD       CHLINE        LINENO            3 0
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
     C/SPACE 5
      ********************************************************************
      * Update the last journal sequence number processed on MXOLTJPD
      ********************************************************************
     C     UPD_MXOLTJ    BEGSR
 
     C     1             CHAIN     MXOLTJPD                           9999
     C     *IN99         IFEQ      '0'
     C                   EVAL      I#LASTSEQ = JrnSeqn
     C                   UPDATE    MXOLTJP0
     C                   ELSE
     C                   EVAL      I#ERMS   = 'ERROR ON CHAIN TO MXOLTJPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Commit the updates
 
     C                   COMMIT
 
     C                   ENDSR
      *********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      *  Check if the feature CMX011 - Midas Export Using Data Queue is installed             CSE040
                                                                                              CSE040
     C                   MOVE      'N'           CMX011            1                          CSE040
                                                                                              CSE040
     C                   CALL      'AOSARDR0'                                                 CSE040
     C                   PARM      *BLANKS       @RTCD                                        CSE040
     C                   PARM      '*VERIFY'     @OPTN                                        CSE040
     C                   PARM      'CMX011'      @SARD             6                          CSE040
                                                                                              CSE040
     C                   IF        @RTCD = *BLANKS                                            CSE040
     C                   EVAL      CMX011 = 'Y'                                               CSE040
     C                   ENDIF                                                                CSE040
                                                                                              CSE040
      ** Get system value 'MQQueueManagerAPI'                                               AR869911
                                                                                            AR869911
     C                   EVAL      PSysValK1 = WConst                                       AR869911
     C                   CALL      'AOSVALR0'                                               AR869911
     C                   PARM      *BLANKS       PRetCode                                   AR869911
     C                   PARM                    PSysValK1                                  AR869911
     C                   PARM                    PSysVal1                                   AR869911
     C                   PARM                    PSysValK2                                  AR869911
     C                   PARM                    PSysVal2                                   AR869911
     C                   PARM                    PSysValK3                                  AR869911
     C                   PARM                    PSysVal3                                   AR869911
     C                   PARM                    PSysValK4                                  AR869911
     C                   PARM                    PSysVal4                                   AR869911
     C                   PARM                    PSysValK5                                  AR869911
     C                   PARM                    PSysVal5                                   AR869911
     C                   PARM                    PSysValK6                                  AR869911
     C                   PARM                    PSysVal6                                   AR869911
     C                   PARM                    PSysValK7                                  AR869911
     C                   PARM                    PSysVal7                                   AR869911
     C                   PARM                    PSysValK8                                  AR869911
     C                   PARM                    PSysVal8                                   AR869911
     C                   PARM                    PSysValK9                                  AR869911
     C                   PARM                    PSysVal9                                   AR869911
     C                   PARM                    PSysValK10                                 AR869911
     C                   PARM                    PSysVal10                                  AR869911
                                                                                            AR869911
     C                   IF        PRetCode <> *BLANKS                                      AR869911
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO AOSVALR0'                     AR869911
     C                   EXSR      *PSSR                                                    AR869911
     C                   ENDIF                                                              AR869911
                                                                                            AR869911
      * Get export control details on data-area
 
     C     *DTAARA       DEFINE                  MXEXPCTL
     C                   IN        MXEXPCTL
 
 
      * If the trace is ON
 
     C     TRACDT        IFEQ      'Y'
 
 
      * Open the printer file
 
     C                   OPEN      MXDRIPTAU
 
      * Initialize the time
 
     C                   TIME                    #TIME
 
      * Output audit report page headings
 
     C                   Z-ADD     *ZERO         CHLINE
     C                   Z-ADD     99            LINENO
     C                   EXSR      PAG
 
     C                   ENDIF
 
     C                   MOVEL     *BLANK        I#RTCD            7
     C                   MOVEL     *BLANK        I#ERMS           30
 
      * Key lists
 
     C     MXCOMDK       KLIST
     C                   KFLD                    MQCOMI            8
     C                   KFLD                    MQEXTT            1
 
     C     MXMQDLK       KLIST
     C                   KFLD                    TGJRNS
     C                   KFLD                    TGCOMI
 
      ** Access system prefix                                                                 CSW039
     C     *dtaara       define                  sdstat                                       CSW039
     C                   in        sdstat                                                     CSW039
     C                   movel     LIBR          p@key                                        244430
      *                                                                                       CSW039
     C                   CALLB     'AOSARDR0'                                                 244430
     C                   PARM      *BLANKS       @RTCD                                        244430
     C                   PARM      '*VERIFY'     @OPTN                                        244430
     C                   PARM      'CSW038'      @SARD                                        244430
     C     SCSARD        PARM      SCSARD        DSFDY                                        244430
     C     @RTCD         IFEQ      *BLANKS                                                    244430
     C                   MOVE      'Y'           CSW038            1                          244430
     C                   ELSE                                                                 244430
     C                   MOVE      'N'           CSW038                                       244430
     C                   ENDIF                                                                244430
     C                   If        CSW038 = 'N'                                               244430
     C                   Call      'RTVNODEREF'                                               CSW039
     C                   Parm      LIBR          HostID            2                          CSW039
     C                   Parm                    noderef           2 0                        CSW039
      *                                                                                       CSW039
     C                   movel     noderef       p@key                                        CSW039
     C**********         move      10            p@key                                 CSW039 244430
     C                   Endif                                                                244430
      *
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
