     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Customer Message Transmission')               *
      *****************************************************************
      *                                                               *
      *  Midas - Kondor Midas Interface                               *
      *                                                               *
      *  XX008002 - SD Midas-Kondor Interface Customer Details        *
      *                                                               *
      *  Function:  This program sends data to XX008003               *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. DRI008  *Create    Date 28Jun23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DRI008 - Midas-Kondor Interface Customer Details             *
      *                                                               *
      *****************************************************************

     FXXMQCUL0  IF   E           K DISK    INFSR(*PSSR)
     F
     FXXMQCUL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(XXMQCUD0:XXMQCUDU)
     F                                     PREFIX(U_)
      * SD Select Customer mesage for MQ Queue

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

      ** Access Object Parameters
     D PRetCode        S              7A
     D PSysValK1       S             20A
     D PSysVal1        S            200A
     D PSysValK2       S             20A
     D PSysVal2        S            200A
     D PSysValK3       S             20A
     D PSysVal3        S            200A
     D PSysValK4       S             20A
     D PSysVal4        S            200A
     D PSysValK5       S             20A
     D PSysVal5        S            200A
     D PSysValK6       S             20A
     D PSysVal6        S            200A
     D PSysValK7       S             20A
     D PSysVal7        S            200A
     D PSysValK8       S             20A
     D PSysVal8        S            200A
     D PSysValK9       S             20A
     D PSysVal9        S            200A
     D PSysValK10      S             20A
     D PSysVal10       S            200A

      ** Parameter
     D P_MGR           S             48A
     D P_MSGQ          S             48A
     D W_OPEN          S              1A   INZ(' ')

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)

     D  sdstat       E DS                  extname(SDSTAT)

      ** message lengths
     D CustMsg       E DS                  extname(XXCUSTTD)
     D CustMsgL        S              5  0
     D p@msglen        S             10I 0

      ** Named constants
     D WConst1         C                   'MQQueueManagerAPI'
     D WConst2         C                   'FBMKondorCustOut'


     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30

     C                   Z-ADD     *ZERO         REC_cnt           6 0
     C                   Z-ADD     *ZERO         MSG_cnt           6 0

     C                   Read      XXMQCUL0                               99

     C                   If        *IN99 = '0'
      * open queue for put

     C                   movel     '*OPEN_PUT '  p@request
     C                   exsr      sr_MQM
     C                   EVAL      W_OPEN = 'Y'
     C                   Endif

      ** Do While records found in Incoming Message
     C                   DOW       *IN99 = '0'

      * Add 1 to count of records read
     C                   add       1             REC_cnt
      *
     C                   z-add     1             eoMp
     C                   clear                   p@msgbuf
     C                   movea     XMQTRN        a@msgbuf(eoMp)
     C                   Eval      p@msglen = CustMsgL

      * Put message to the MQ queue

     C                   EXSR      PUT_MSG

     C                   READ      XXMQCUL0                               99
     C                   ENDDO

      * Close the MQ series queue

     C                   SETON                                        LR
      *
     C                   If        W_OPEN = 'Y'
     C                   movel     '*CLOSE    '  p@request
     C                   clear                   p@msgbuf
     C                   exsr      sr_MQM
     C                   Endif

     C                   Return

      *******************************************************************
     C/SPACE 5
      ********************************************************************
      * Determine if the message should be 'put' to the MQ Series queue
      ********************************************************************
     C     PUT_MSG       begsr

      * 'Put' the existing message

     C                   movel     '*PUT      '  p@request
     C                   exsr      sr_MQM

     C                   add       1             MSG_cnt
     C                   EXSR      UPD_SNTST

      * Reset the message buffer and end of message pointer

     C                   clear                   p@msgbuf
     C                   z-add     1             eoMp

     C                   endsr
     C*********************************************************************
     C/SPACE 5
      ********************************************************************
      * Do MQ Series Queue Operations
      *********************************************************************
     C     sr_MQM        begsr

     C                   CALL      'XX008003'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      ** Queue Manager
      * Request
      * Queue Name
      * Message Buffer
     C                   parm                    p@request        10
     C                   parm      P_MGR         p@qmnager        48
     C                   parm      P_MSGQ        p@queuenm        48
     C                   parm                    p@msgbuf      32000
     C                   parm                    p@key             2
     C                   parm                    p@msglen

      * Error
     C     W#ERMS        IFNE      *BLANK
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO XX008003'
     C                   EVAL      DBFILE = 'XX008003'
     C                   EVAL      DBASE  = 2
     C                   EVAL      DBKEY  = W#ERMS
     C                   EXSR      *PSSR
     C                   endif

     C                   endsr
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Update Message Status on XXRTGSPD
      ********************************************************************
     C     UPD_SNTST     BEGSR

      * Update 'Sent Status' in XXMQCUTD

     C                   EVAL      *IN99 = '0'
     C     K_MQCU        Chain     XXMQCUDU                           99        *
     C     *in99         Ifeq      '0'
     C                   Eval      U_XSNTST = 'Y'
     C                   Update    XXMQCUDU
     C                   Else

      * If not found, database error 4
     C                   Eval      DBFILE = 'XXMQCUTD'
     C                   Eval      DBASE  = 4
     C                   Eval      DBKEY  = XUREF
     C                   Exsr      *PSSR
     C                   Endif

     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR

      *  DBPGM
     C                   EVAL      DBPGM = 'XX008002'
      *
      *  Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Get system value 'MQQueueManagerAPI' and 'FBMKondorCustOut'

     C                   EVAL      PSysValK1 = WConst1
     C                   EVAL      PSysValK2 = WConst2
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    PSysValK1
     C                   PARM                    PSysVal1
     C                   PARM                    PSysValK2
     C                   PARM                    PSysVal2
     C                   PARM                    PSysValK3
     C                   PARM                    PSysVal3
     C                   PARM                    PSysValK4
     C                   PARM                    PSysVal4
     C                   PARM                    PSysValK5
     C                   PARM                    PSysVal5
     C                   PARM                    PSysValK6
     C                   PARM                    PSysVal6
     C                   PARM                    PSysValK7
     C                   PARM                    PSysVal7
     C                   PARM                    PSysValK8
     C                   PARM                    PSysVal8
     C                   PARM                    PSysValK9
     C                   PARM                    PSysVal9
     C                   PARM                    PSysValK10
     C                   PARM                    PSysVal10

     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO AOSVALR0'
     C                   EVAL      DBFILE = 'SDSVLBTD'
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBKEY  = 'MQ MGR AND MQ Queue'
     C                   EXSR      *PSSR
     C                   ENDIF

      * Keep value of MQ manager and MQ Queue

     C                   EVAL      P_MGR  = %TRIM(PSysVal1)
     C                   EVAL      P_MSGQ = %TRIM(PSysVal2)

      * Reset the message buffer and end of message pointer

     C                   clear                   p@msgbuf
     C                   z-add     1             eoMp              6 0

      * Setup message lengths

     C                   EVAL      CustMsgL = %LEN(CustMsg)

     C     K_MQCU        KList
     C                   KFld                    XMCUST
     C                   KFld                    XUREF

     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      *****************************************************************
      *                                                               *
      *  *PSSR    : PSSR subroutine                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   DUMP
     C                   SETON                                        LRU7U8
      *
     C                   IF        W_OPEN = 'Y'
     C                   movel     '*CLOSE    '  p@request
     C                   clear                   p@msgbuf
     C                   exsr      sr_MQM
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2023
