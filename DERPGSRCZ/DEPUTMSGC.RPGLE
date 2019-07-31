     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Put message on MQM queue controller')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPUTMSGC - Put Message on MQM Queue Controller              *
      *                                                               *
      *  Function:  This program controls putting messages onto an    *
      *             MQSeries queue.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *  Prev Amend No. CDE002             Date 05Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 19Nov99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Literals to pass between modules to indicate message type
     D SDMsgTyp        C                   'SDAVAIL'
     D*SDAvTxt*******  C                   'STANDING DATA AVAILABLE'                          CDE002
     D*TRMsgTyp******  C                   'TRAVAIL'                                          CDE002
     D*TRAvTxt*******  C                   'TRANSACTION EXTRACT DATA AVAILABLE'               CDE002
     D TRMsgTyp        C                   'TRAVAIL'                                          CDE002
     D RVMsgTyp        C                   'RVAVAIL'                                          CDE002
     D CSMsgTyp        C                   'COBSTART'                                         CDE002
     D CFMsgTyp        C                   'COBFINISHED'                                      CDE002
     D RSMsgTyp        C                   'RESYNCSTART'                                      CDE002
     D REMsgTyp        C                   'RESYNCEND'                                        CDE002
     D BKMsgTyp        C                   'SDBANKPD_A'                                       CDE002
     D Meridian        C                   'MERIDIAN'                                         CDE002
     D BKFormat        C                   'SDBANKPD'                                         CDE002
                                                                                              CDE002
 
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
 
      ** Data structure to define message format.
     D                 DS
     D P@MsgBuf                1  32000
     D  P@MsgTyp               1     32
     D**P@Message************139  32000                                                       CDE002
     D  P@Meridian           101    108                                                       CDE002
     D  P@RunDate            139    145                                                       CDE002
     D  P@Format             141    148                                                       CDE002
     D  P@BANK               159    168                                                       CDE002
     D  P@CNCD               169    170                                                       CDE002
     D  P@CYCD               171    173                                                       CDE002
     D  P@HOCY               174    176                                                       CDE002
     D  P@LCCY               177    179                                                       CDE002
     D  P@SBRC               180    182                                                       CDE002
     D  P@CUST               183    188                                                       CDE002
     D  P@SLCD               189    191                                                       CDE002
     D  P@RDNB               193    198  0                                                    CDE002
     D  P@LCD                200    205  0                                                    CDE002
     D  P@TYLC               206    206                                                       CDE002
     D  P@SUC                207    207                                                       CDE002
     D  P@DFIN               208    208                                                       CDE002
     D  P@MRDT               209    215                                                       CDE002
     D  P@DNWD               217    222  0                                                    CDE002
     D  P@EYD                224    229  0                                                    CDE002
     D  P@PEYD               231    236  0                                                    CDE002
     D  P@BVPD               238    241  0                                                    CDE002
     D  P@URPT               242    294                                                       CDE002
     D  P@PCFU               295    295                                                       CDE002
     D  P@PCFQ               297    300  0                                                    CDE002
     D  P@MDEL               301    301                                                       CDE002
     D  P@MODT               302    302                                                       CDE002
                                                                                              CDE002
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CDE002
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CDE002
 
     C     *LIKE         DEFINE    Ret_Code      I#RTCD
     C     *LIKE         DEFINE    Err_Mess      I#ERMS
 
     C     *ENTRY        PLIST
     C                   PARM                    Ret_Code          7
     C                   PARM                    Err_Mess         30
     C                   PARM                    W@SdTr            2
     C                   PARM                    P@QueueNm        48
                                                                                              CDE002
      **  Access Bank Details                                                                 CDE002
                                                                                              CDE002
     C                   CALLB     'AOBANKR0'                                                 CDE002
     C                   PARM      '*DBERR  '    @RTCD             7                          CDE002
     C                   PARM      '*FIRST  '    @OPTN             7                          CDE002
     C     SDBANK        PARM      SDBANK        DSFDY                                        CDE002
 
     C                   EXSR      SR_PUT
 
     C                   MOVEL     '*CLOSE    '  W@Request
     C                   EXSR      SR_MQM
     C                   SETON                                        LR
 
      *****************************************************************
      *                                                               *
      * SR_PUT - Subroutine to find put a message                     *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: SR_MQM                                                 *
      *                                                               *
      *****************************************************************
     C     SR_PUT        BEGSR
 
      * open queue for put
     C                   MOVEL     '*OPEN_PUT '  W@Request
     C                   EXSR      SR_MQM
 
      * put
     C                   MOVEL     '*PUT      '  W@Request
                                                                                              CDE002
     C*****W@SdTr********IFEQ      'SD'                                                       CDE002
     C*******************MOVEL     SDMsgTyp      P@MsgTyp                                     CDE002
     C*******************MOVEL     SDAvTxt       P@Message                                    CDE002
     C*******************ELSE                                                                 CDE002
     C*******************MOVEL     TRMsgTyp      P@MsgTyp                                     CDE002
     C*******************MOVEL     TRAvTxt       P@Message                                    CDE002
     C*******************ENDIF                                                                CDE002
                                                                                              CDE002
     C                   SELECT                                                               CDE002
     C     W@SdTr        WHENEQ    'SD'                                                       CDE002
     C                   MOVEL     SDMsgTyp      P@MsgTyp                                     CDE002
     C     W@SdTr        WHENEQ    'TR'                                                       CDE002
     C                   MOVEL     TRMsgTyp      P@MsgTyp                                     CDE002
     C     W@SdTr        WHENEQ    'RV'                                                       CDE002
     C                   MOVEL     RVMsgTyp      P@MsgTyp                                     CDE002
     C     W@SdTr        WHENEQ    'CS'                                                       CDE002
     C                   MOVEL     CSMsgTyp      P@MsgTyp                                     CDE002
     C     W@SdTr        WHENEQ    'CF'                                                       CDE002
     C                   MOVEL     CFMsgTyp      P@MsgTyp                                     CDE002
     C     W@SdTr        WHENEQ    'RS'                                                       CDE002
     C                   MOVEL     RSMsgTyp      P@MsgTyp                                     CDE002
     C     W@SdTr        WHENEQ    'RE'                                                       CDE002
     C                   MOVEL     REMsgTyp      P@MsgTyp                                     CDE002
     C     W@SdTr        WHENEQ    'BK'                                                       CDE002
     C                   MOVEL     BKMsgTyp      P@MsgTyp                                     CDE002
     C                   ENDSL                                                                CDE002
                                                                                              CDE002
     C     W@SdTr        IFNE      'BK'                                                       CDE002
     C                   MOVEL     ' 0'          P@RunDate                                    CDE002
     C                   MOVE      BJRDNB        P@RunDate                                    CDE002
     C                   ELSE                                                                 CDE002
     C                   MOVEL     Meridian      P@Meridian                                   CDE002
     C                   MOVEL     BKFormat      P@Format                                     CDE002
     C                   MOVEL     BJBANK        P@BANK                                       CDE002
     C                   MOVEL     BJCNCD        P@CNCD                                       CDE002
     C                   MOVEL     BJCYCD        P@CYCD                                       CDE002
     C                   MOVEL     BJHOCY        P@HOCY                                       CDE002
     C                   MOVEL     BJLCCY        P@LCCY                                       CDE002
     C                   MOVEL     BJSBRC        P@SBRC                                       CDE002
     C                   MOVEL     BJCUST        P@CUST                                       CDE002
     C                   MOVEL     BJSLCD        P@SLCD                                       CDE002
     C                   Z-ADD     BJRDNB        P@RDNB                                       CDE002
     C                   Z-ADD     BJLCD         P@LCD                                        CDE002
     C                   MOVEL     BJTYLC        P@TYLC                                       CDE002
     C                   MOVEL     BJSUC         P@SUC                                        CDE002
     C                   MOVEL     BJDFIN        P@DFIN                                       CDE002
     C                   MOVEL     BJMRDT        P@MRDT                                       CDE002
     C                   Z-ADD     BJDNWD        P@DNWD                                       CDE002
     C                   Z-ADD     BJEYD         P@EYD                                        CDE002
     C                   Z-ADD     BJPEYD        P@PEYD                                       CDE002
     C                   Z-ADD     BJBVPD        P@BVPD                                       CDE002
     C                   MOVEL     BJURPT        P@URPT                                       CDE002
     C                   MOVEL     BJPCFU        P@PCFU                                       CDE002
     C                   Z-ADD     BJPCFQ        P@PCFQ                                       CDE002
     C                   MOVEL     BJMDEL        P@MDEL                                       CDE002
     C                   MOVEL     BJMODT        P@MODT                                       CDE002
     C                   ENDIF                                                                CDE002
                                                                                              CDE002
     C                   EXSR      SR_MQM
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR_MQM - Subroutine to call the put message module            *
      *                                                               *
      * Called by: Main processing, SR_PUT                            *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     SR_MQM        BEGSR
 
     C                   CALLB     'DEPUTMSG'
     C                   PARM                    Ret_Code          7
     C                   PARM                    Err_Mess         30
     C                   PARM                    W@Request        10
     C                   PARM                    P@QueueNm        48
     C                   PARM                    P@MsgBuf      32000
     C     Ret_Code      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEPUTMSG'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDSR
     C*********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
