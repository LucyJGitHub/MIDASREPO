     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Midas-Plato interface pre-proc PF/SECTYD')
      *****************************************************************
      *                                                               *
      *  Meridian DBA Replication                                     *
      *                                                               *
      *  RP1125 - Midas-Plato Interface                               *
      *           Replication Pre-Processing Program for PF/SECTYD.   *
      *                                                               *
      * This program is called as part of the Meridian Replication    *
      *  system for the Midas-Plato Interface.                        *
      * For each record on PF/SECTYD, the following message format    *
      *   will be output to Meridian:                                 *
      *                                                               *
      *  SESECINV - Format of PF/SECTYD joined with PF/INVTPD.        *
      * ->                                                            *
      *¦ SEDVASEC - Format of PF/SEDEVD joined with PF/SECTYD.        *
      * --                                                            *
      * ->                                                            *
      *¦ SEDVFSEC - Format of PF/SNDEVD joined with PF/SECTYD.        *
      * --                                                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
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
      *  MD046248 - Finastra Rebranding                               *
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
      *   *IN80 - End of records for key on LF/SECED.                 *
      *   *IN90 - End of records for key on PF/INVTPD.                *
      *   *INU7 - Error encountered in processing.                    *
      *   *INLR - Last Record - End program.                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     F*
     FSECTY     IF   E           K DISK    PREFIX(S)
     FINVTP     IF   E           K DISK    PREFIX(I)
     FSECED     IF   E           K DISK    INFDS(SECEDds)
     F                                     PREFIX(E)
 
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
 
      **   Format for PF/SECTYD
     D SECTYDds      E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(S)
      **   Format for PF/INVTPD
     D INVTPDds      E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(I)
      **   Format for PF/SEDEVD
     D SEDEVDds      E DS                  EXTNAME(SEDEVD)
     D                                     PREFIX(E)
      **   Format for PF/SNDEVD
     D SNDEVDds      E DS                  EXTNAME(SNDEVD)
     D                                     PREFIX(E)
     D ERECI1        E                     EXTFLD(RECI      )
     D EZZ0051       E                     EXTFLD(ZZ005     )
      **   Format for Information DS for LF/SEDEV
     D SECEDds         DS
     D   @KFormat            261    270
 
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
      **   Key to PF/SECTYD and PF/INVTPD.
     D @KSESN          S                   LIKE(SSESN) INZ(*Blanks)
     D @KCCYI          S                   LIKE(ICCYI) INZ(*Blanks)
     D @KINVT          S                   LIKE(IINVT) INZ(*Blanks)
      **   Output queue name
     D OutQueue2       S                   LIKE(MQSQueue)
 
     DOutParms         DS
     D   OutData                           LIKE(TransData) INZ(*BLANKS)
     D   OutLen                       4S 0 INZ(*ZERO)
     DSecParms         DS
     D   SecData                           LIKE(TransData) INZ(*BLANKS)
     D   SecLen                            LIKE(OutLen) INZ(*ZERO)
     DWrkParms         DS
     D   WrkData                           LIKE(TransData) INZ(*BLANKS)
     D   WrkLen                            LIKE(OutLen) INZ(*ZERO)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
     ISNDEVDF
     I              RECI                        ERECI1
     I              ZZ005                       EZZ0051
 
      /EJECT
 
      ** +--------------------------------------+
      ** ¦ Start F-specs                        ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
     C* Extract the key fields from the data input.
 
     C                   Eval      @KSESN  = %subst(TransData:22:10)
 
     C* Access original record on PF/SECTYD.
 
     C     @KSESN        Chain     SECTYDF                            90
 
      ** If error then perform any special processing and exit
     C                   If        *IN90 <> '0'
     C                   Exsr      *PSSR
     C                   EndIf
 
     C* Format the data from PF/PRICED for Meridian.
 
     C                   Eval      InData   = SECTYDds
     C                   Eval      InDBFile = 'SECTYD    '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
 
     C* Contruct the compound messgae format.
 
     C                   Eval      WrkParms = OutParms
 
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
     C                   Eval      WrkLen = WrkLen + OutLen
 
     C* Send the message for SEPRCSEC
 
     C                   Eval      RAMSGTYPE=('SESECINV_A')
     C                   Exsr      #SNDMSG
 
     C* Save the message format for PF/SECTYD joined to PF/INVTPD.
 
     C                   Eval      SecParms = WrkParms
 
     C* Read all Security Diary entried for the security being processed.
 
     C     @KSESN        SetLL     SECED
     C     @KSESN        ReadE     SECED                                  80
 
     C     *IN80         DowEq     '0'
 
     C* Format the data from PF/SEDEVD for Meridian.
 
     C     @KFormat      IfEq      'SEDEVDF   '
     C                   Eval      InData   = SEDEVDds
     C                   Eval      InDBFile = 'SEDEVD    '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
     C                   Eval      RAMSGTYPE=('SEDVASEC_A')
     C                   EndIf
 
     C     @KFormat      IfEq      'SNDEVDF   '
     C                   Eval      InData   = SNDEVDds
     C                   Eval      InDBFile = 'SNDEVD    '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
     C                   Eval      RAMSGTYPE=('SEDVFSEC_A')
     C                   EndIf
 
     C* Output a message for the record format for PF/SEDEVD or PF/SNDEVD,
     C*   joined with the record format received for PF/SECTYD and PF/INVTPD
 
     C                   Reset                   WrkData
     C                   Eval      WrkData  = OutData
     C                   Eval      %subst(WrkData:OutLen) = SecData
 
     C* Send the message for SEDVASEC or SEDVFSEC.
 
     C                   Exsr      #SNDMSG
 
     C     @KSESN        ReadE     SECED                                  80
     C                   EndDo
 
 
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
 
      ** If error in RP1125, set Return Code accordingly.
     C                   If        ReturnCode = *blank
     C                   Eval      ReturnCode = ('ErrRP1125')
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
 
     C* Key list for LF/INVTP.
     C     @KINVTP       KLIST
     C                   KFLD                    @KCCYI
     C                   KFLD                    @KINVT
 
     C                   ENDSR
      *****************************************************************
