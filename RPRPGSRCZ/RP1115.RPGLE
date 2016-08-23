     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Midas-Plato interface pre-proc PF/PRICEM')
      *****************************************************************
      *                                                               *
      *  Meridian DBA Replication                                     *
      *                                                               *
      *  RP1115 - Midas-Plato Interface                               *
      *           Replication Pre-Processing Program for PF/PRICED.   *
      *                                                               *
      * This program is called as part of the Meridian Replication    *
      *  system for the Midas-Plato Interface.                        *
      * For each record on PF/PRICED, the following message format    *
      *   will be output to Meridian:                                 *
      *                                                               *
      *  SEPRCSEC - Format of PF/PRICED joined with PF/SECTYD and     *
      *             PF/INVTPD.                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL031             Date 05Jul04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 12Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 177415             Date 22Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPL003  *CREATE    Date 09Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CSE023 - Treaty Withholding Tax.                             *
      *  177415 - Replication performance improvements.               *
      *           Do not close database files by not setting on *INLR.*
      *  CPL003 - Midas-Plato Interface                               *
      *                                                               *
      *****************************************************************
      *  Indicator Usage:                                             *
      *   *IN80 - End of records for key on PF/SECTYD and PF/INVTPD.  *
      *   *INU7 - Error encountered in processing.                    *
      *   *INLR - Last Record - End program.                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     F*
     FPRICED    IF   E           K DISK    PREFIX(P)
     FSECTY     IF   E           K DISK    PREFIX(S)
     FINVTP     IF   E           K DISK    PREFIX(I)
 
      /EJECT
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      * Following /COPY is the procedure prototype for the Format routine
      /COPY RPCPYSRC,RPFMTPPF
 
      ** The following /COPY contains various standard declares
     C/COPY RPCPYSRC,Std_Dcl
 
      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
     C/COPY RPCPYSRC,Mdn_Hd_DS
 
      **   Composite Data
     D CompData        S                   LIKE(TransData) INZ(*BLANKS)
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **   Format for PF/PRICED
     D PRICEDds      E DS                  EXTNAME(PRICED)
     D                                     PREFIX(P)
      **   Format for PF/SECTYD
     D SECTYDds      E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(S)
      **   Format for PF/INVTPD
     D INVTPDds      E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(I)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters
      **   Parameters for ProcFormat
     D   InData        S                   LIKE(TransData) INZ(*Blanks)
     D   InDBFile      S             10A   INZ(*Blanks)
     D   InDecSep      S              1A   INZ('.')
     D   InShwPosSn    S              1A   INZ('N')
      **   Key to PF/PRICED.
     D@KPRICEDds       DS
     D @KPSSN                              LIKE(PPSSN) INZ(*Blanks)
     D @KPPRT                              LIKE(PPPRT) INZ(*Blanks)
     D @KPVDTP                             LIKE(PPVDT) INZ(*Zeros)
     D @KPVDTA                13     17A
     D @KPVDTS                13     17S 0 INZ(*Zeros)
      **   Output queue name
     D OutQueue2       S                   LIKE(MQSQueue)
 
     DOutParms         DS
     D   OutData                           LIKE(TransData) INZ(*BLANKS)
     D   OutLen                       4S 0 INZ(*ZERO)
     DWrkParms         DS
     D   WrkData                           LIKE(TransData) INZ(*BLANKS)
     D   WrkLen                            LIKE(OutLen) INZ(*ZERO)
      **   Key to PF/INVTPD.
     D @KCCYI          S                   LIKE(ICCYI) INZ(*Blanks)
     D @KINVT          S                   LIKE(IINVT) INZ(*Blanks)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
      /EJECT
 
      ** +--------------------------------------+
      ** ¦ Start F-specs                        ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
     C* Extract the key fields from the data input.
 
     C                   Eval      @KPSSN  = %subst(TransData:22:10)
     C                   Eval      @KPPRT  = %subst(TransData:32:2)
     C                   Eval      @KPVDTA = %subst(TransData:36:5)
     C                   Eval      @KPVDTP = @KPVDTS
 
     C* Access original record on PF/PRICED.
 
     C     @KPRICED      Chain     PRICEDF                            90
 
      ** If error then perform any special processing and exit
     C                   If        *IN90 <> '0'
     C                   Exsr      *PSSR
     C                   EndIf
 
     C* Format the data from PF/PRICED for Meridian.
 
     C                   Eval      InData   = PRICEDds
     C                   Eval      InDBFile = 'PRICED    '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
 
     C* Contruct the compound messgae format.
 
     C                   Eval      WrkParms = OutParms
 
     C* Access the related record on LF/SECTY.
 
     C     @KPSSN        Chain     SECTYDF                            90
 
      ** If Price record is live, but Security is not found, raise error
     C**********         If        (SRECI = 'D') And (*IN90 <> '0')             177415
     C                   If        (PRECI = 'D') And (*IN90 <> '0')             177415
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** If Price record is NOT live, and Security is not found, ignore
     C                   If        (*IN90 = '0')
 
     C* Format the data from PF/SECTYD for Meridian.
 
     C                   Eval      InData   = SECTYDds
     C                   Eval      InDBFile = 'SECTYD    '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
 
     C* Contruct the compound message format.
 
     C                   Eval      %subst(WrkData:WrkLen) = OutData
     C                   Eval      WrkLen = WrkLen + OutLen - 1
 
     C* Access the related record on LF/INVTP.
 
     C                   Eval      @KCCYI   = SNMCY
     C                   Eval      @KINVT   = SSITP
     C     @KINVTP       Chain     INVTPDF                            90
 
      ** If error then perform any special processing and exit
     C                   If        *IN90 <> '0'
     C                   Exsr      *PSSR
     C                   EndIf
 
     C* Format the data from PF/INVTPD for Meridian.
 
     C                   Eval      InData   = INVTPDds
     C                   Eval      InDBFile = 'INVTPD    '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
 
     C* Contruct the compound messgae format.
 
     C                   Eval      %subst(WrkData:WrkLen) = OutData
 
     C* Send the message for SEPRCSEC
 
     C                   Eval      RAMSGTYPE=('SEPRCSEC_A')
     C                   Exsr      #SNDMSG
 
     C                   EndIf
 
     C* Return control at the end of the processing for the message.
 
     C                   Commit
     C**********         Seton                                        LR        177415
     C                   Return
 
      *****************************************************************
      /EJECT
      **********************************************************************
      **                                                                  **
      ** SR/#SNDMSG - Send Meridian Message to MQ Queue                   **
      ** ==========                                                       **
      ** Parameters:                                                      **
      ** ===========                                                      **
      **  In : OutQueue     48A  Name of MQ message queue for output.     **
      **       MdnHeadDS   138A  Meridian header details (PF/RPMDHDPD)    **
      **       CompData   5000A  Meridian message data.                   **
      **       CommitCtl     1A  Indicator for Commitment Control (Y/N)   **
      **                                                                  **
      **  Out: ReturnCode   10A  Return code from sending MQ message      **
      **                                                                  **
      ** Description:                                                     **
      ** ============                                                     **
      **  Receive above parameters and write message to Meridian MQ       **
      **   message queue. If error, dump program.                         **
      **                                                                  **
      **********************************************************************
 
     C     #SNDMSG       Begsr
 
     C* Set up the Operation and Table fields on the message.
 
     C                   Eval      CompData =  %subst(TransData:1:20)
     C                   Eval      %subst(CompData:21) = WrkData
 
     C* Call a standard routine to actually send the message
     C                   CallB     'RPSNDMSG'
     C                   Parm      OutQueue1     OutQueue2
     C                   Parm                    MdnHeadDS
     C                   Parm                    CompData
     C                   Parm                    CommitCtl
     C                   Parm                    ReturnCode
 
      ** If error then perform any special processing and exit
     C                   If        ReturnCode <> *blank
     C                   Exsr      *PSSR
     C                   EndIf
 
     C     #SNDMSGEnd    Endsr
 
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
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         Begsr
 
      ** If error in RP1115, set Return Code accordingly.
     C                   If        ReturnCode = *blank
     C                   Eval      ReturnCode = ('ErrRP1115')
     C                   EndIf
 
     C     @RUN          IfEq      *BLANK
     C                   Move      'Y'           @RUN              1
     C                   Dump
     C                   EndIf
 
     C                   SetOn                                        U7U8LR
     C                   Return
 
     C                   Endsr
      *
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * MQSeries queue to write to - this parameter IS used in this module
     C                   PARM                    OutQueue1        48
      * Merdian header
     C                   PARM                    MdnHeadDS
      * Transaction Data
     C                   PARM                    TransData
      * Commitment control flag
     C                   PARM                    CommitCtl
      * Return Code
     C                   PARM                    ReturnCode
 
     C* Key list for PF/PRICED.
     C     @KPRICED      KLIST
     C                   KFLD                    @KPSSN
     C                   KFLD                    @KPPRT
     C                   KFLD                    @KPVDTP
 
     C* Key list for LF/INVTP.
     C     @KINVTP       KLIST
     C                   KFLD                    @KCCYI
     C                   KFLD                    @KINVT
 
     C                   ENDSR
      *****************************************************************
