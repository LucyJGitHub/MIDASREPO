     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Midas-Plato interface pre-proc PF/DEALSDG')   *
      *****************************************************************
      *                                                               *
      *  Meridian DBA Replication                                     *
      *                                                               *
      *  RP1145 - Midas-Plato Interface                               *
      *           Replication Pre-Processing Program for PF/DEALSDG.  *
      *                                                               *
      * This program is called as part of the Meridian Replication    *
      *  system for the Midas-Plato Interface.                        *
      * For each record on PF/DEALSDG, the following message format   *
      *   will be output to Meridian:                                 *
      *                                                               *
      *  DEALSDG  - Format of PF/DEALSDG.                             *
      * ->                                                            *
      *¦ IRDATSWP - Format of PF/DLDTSCPD joined with PF/DEALSDG.     *
      *¦ IRCFLSWP - Format of PF/DLCFSCPD joined with PF/DEALSDG.     *
      *¦ IRPRCSWP - Format of PF/DLPCSCPD joined with PF/DEALSDG.     *
      * --                                                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 15Feb17               *
      *                 CDL096             Date 22Sep14               *
      *                 MD030364           Date 10Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CPL004             Date 21Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 177415             Date 22Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPL003  *CREATE    Date 14Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  MD030364 - Compilation issue for BFM 2.1 SP6 Drop2           *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation (Recompile)             *
      *  CPL004 - Midas-Plato Interface.                              *
      *           Enhancements for Plato v4.80.                       *
      *           Output a rate fix or interest payment frequency of  *
      *           "Z" if there are records on the schedule and the    *
      *           frequency has been blanked on PF/DEALSDG.           *
      *  177415 - Replication performance improvements.               *
      *           Do not close database files by not setting on *INLR.*
      *  CPL003 - Midas-Plato Interface                               *
      *                                                               *
      *****************************************************************
      *  Indicator Usage:                                             *
      *   *IN80 - End of records for key on LF/DLDETUL0.              *
      *   *INU7 - Error encountered in processing.                    *
      *   *INLR - Last Record - End program.                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     F*
     F*DEALS****IF   E           K DISK    IGNORE(DEALSDAF:DEALSDBF)            177415
     F**********                           IGNORE(DEALSDCF:DEALSDDF)            177415
     F**********                           IGNORE(DEALSDEF:DEALSDFF)            177415
     F**********                           PREFIX(D)                            177415
     FDEALS     IF   E           K DISK    PREFIX(D)                            177415
     FDLDETUL0  IF   E           K DISK    INFDS(DLDETds)
     F                                     PREFIX(S)
     FDLDTSCL0  IF   E           K DISK    RENAME(DLDTSCD0:DLDTSCR0)            CPL004
     FDLCFSCL0  IF   E           K DISK    RENAME(DLCFSCD0:DLCFSCR0)            CPL004

      /EJECT
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      * Following /COPY is the procedure prototype for the Format routine
      /COPY RPCPYSRC,RPFMTPPF

      ** The following /COPY contains various standard declares
     C***/COPY*RPCPYSRC,Std_Dcl
     C/COPY RPCPYSRC,STD_DCL                                                                MD030364
                                                                                            MD030364
      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
     C***/COPY*RPCPYSRC,Mdn_Hd_DS                                                           MD030364
     C/COPY RPCPYSRC,MDN_HD_DS                                                              MD030364

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

      **   Format for PF/DEALSDG
     D DEALSDGds     E DS                  EXTNAME(DEALSDG)
     D                                     PREFIX(D)
      **   Format for PF/DLDTSCPD
     D DLDTSCPDds    E DS                  EXTNAME(DLDTSCPD)
     D                                     PREFIX(S)
     D SDLNO1        E                     EXTFLD(DLNO      )
     D SOTIN1        E                     EXTFLD(OTIN      )
     D SPRDT1        E                     EXTFLD(PRDT      )
     D SCOHO1        E                     EXTFLD(COHO      )
     D SDTPR1        E                     EXTFLD(DTPR      )
      **   Format for PF/DLCFSCPD
     D DLCFSCPDds    E DS                  EXTNAME(DLCFSCPD)
     D                                     PREFIX(S)
     D SDLNO2        E                     EXTFLD(DLNO      )
     D SOTIN2        E                     EXTFLD(OTIN      )
     D SPRDT2        E                     EXTFLD(PRDT      )
     D SCOHO2        E                     EXTFLD(COHO      )
     D SDTPR2        E                     EXTFLD(DTPR      )
      **   Format for PF/DLPCSCPD
     D DLPCSCPDds    E DS                  EXTNAME(DLPCSCPD)
     D                                     PREFIX(S)
     D SDLNO3        E                     EXTFLD(DLNO      )
     D SOTIN3        E                     EXTFLD(OTIN      )
     D SPRDT3        E                     EXTFLD(PRDT      )
     D SCOHO3        E                     EXTFLD(COHO      )
     D SDTPR3        E                     EXTFLD(DTPR      )
      **   Format for Information DS for LF/DLDETUL0
     D DLDETds         DS
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
      **   Key to PF/DEALSDG.
     D@KDLDETds        DS
     D @KDLNOA                 1      6    INZ(*Blanks)
     D @KDLNO                  1      6S 0 INZ(*Zeros)
      **   Key to LF/DLDTSCL0.                                                  CPL004
     D@KDLSTSds        DS                                                       CPL004
     D @KDDLNO                             LIKE(SDLNO1)                         CPL004
     D @KDOTIN                             LIKE(SOTIN1)                         CPL004
     D @KDRCIP                             LIKE(RCIP)                           CPL004
      **   Key to LF/DLCFSCL0.                                                  CPL004
     D@KCFSTSds        DS                                                       CPL004
     D @KCDLNO                             LIKE(SDLNO2)                         CPL004
     D @KCOTIN                             LIKE(SOTIN2)                         CPL004
      **   Output queue name
     D OutQueue2       S                   LIKE(MQSQueue)

     DOutParms         DS
     D   OutData                           LIKE(TransData) INZ(*BLANKS)
     D   OutLen                       4S 0 INZ(*ZERO)
     DDlgParms         DS
     D   DlgData                           LIKE(TransData) INZ(*BLANKS)
     D   DlgLen                            LIKE(OutLen) INZ(*ZERO)
     DWrkParms         DS
     D   WrkData                           LIKE(TransData) INZ(*BLANKS)
     D   WrkLen                            LIKE(OutLen) INZ(*ZERO)

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************

     IDLDTSCD0
     I              DLNO                        SDLNO1
     I              OTIN                        SOTIN1
     I              PRDT                        SPRDT1
     I              COHO                        SCOHO1
     I              DTPR                        SDTPR1

     IDLCFSCD0
     I              DLNO                        SDLNO2
     I              OTIN                        SOTIN2
     I              PRDT                        SPRDT2
     I              COHO                        SCOHO2
     I              DTPR                        SDTPR2

     IDLPCSCD0
     I              DLNO                        SDLNO3
     I              OTIN                        SOTIN3
     I              PRDT                        SPRDT3
     I              COHO                        SCOHO3
     I              DTPR                        SDTPR3
      /EJECT

      ** +--------------------------------------+
      ** ¦ Start F-specs                        ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

     C* Extract the Deal Number from the data input.

     C                   Eval      @KDLNOA = %subst(TransData:24:6)

     C* Access original record on PF/DEALSDG.

     C     @KDLNO        Chain     DEALSDGF                           90

      ** If error then perform any special processing and exit
     C                   If        *IN90 <> '0'
     C                   Exsr      *PSSR
     C                   EndIf

     C* Check the Frequency Codes.                                              CPL004
                                                                                CPL004
     C                   Exsr      #CHKFRQ                                      CPL004
                                                                                CPL004
     C* Format the data from PF/DEALSDG for Meridian.

     C                   Eval      InData   = DEALSDGds
     C                   Eval      InDBFile = 'DEALSDG   '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)

     C* Output a message for the record format for PF/DEALSDG.

     C                   Eval      WrkData  = OutData
     C                   Eval      RAMSGTYPE=('DEALSDG_A ')
     C                   Exsr      #SNDMSG

     C* Contruct the compound message format.

     C                   Eval      DlgParms = OutParms

     C* Read all Swap Schedule entries for the Swap being processed.

     C     @KDLNO        SetLL     DLDETUL0
     C     @KDLNO        ReadE     DLDETUL0                               80

     C     *IN80         DowEq     '0'

     C* Format the data from PF/DLDTSCPD for Meridian.

     C     @KFormat      IfEq      'DLDTSCD0  '
     C                   Eval      InData   = DLDTSCPDds
     C                   Eval      InDBFile = 'DLDTSCPD  '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
     C                   Eval      RAMSGTYPE=('IRDATSWP_A')
     C                   EndIf

     C* Format the data from PF/DLCFSCPD for Meridian.

     C     @KFormat      IfEq      'DLCFSCD0  '
     C                   Eval      InData   = DLCFSCPDds
     C                   Eval      InDBFile = 'DLCFSCPD  '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
     C                   Eval      RAMSGTYPE=('IRCFLSWP_A')
     C                   EndIf

     C* Format the data from PF/DLPCSCPD for Meridian.

     C     @KFormat      IfEq      'DLPCSCD0  '
     C                   Eval      InData   = DLPCSCPDds
     C                   Eval      InDBFile = 'DLPCSCPD  '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
     C                   Eval      RAMSGTYPE=('IRPRCSWP_A')
     C                   EndIf

     C* Output a message for the compound message format.

     C                   Reset                   WrkData
     C                   Eval      WrkData  = OutData
     C                   Eval      %subst(WrkData:OutLen) = DlgData

     C* Send the message for IRDATSWP, IRCFLSWP or IRPRCSWP.

     C                   Exsr      #SNDMSG

     C     @KDLNO        ReadE     DLDETUL0                               80
     C                   EndDo


     C* Return control at the end of the processing for the message.

     C                   Commit
     C**********         Seton                                        LR        177415
     C                   Return
                                                                                CPL004
      *****************************************************************         CPL004
      /EJECT                                                                    CPL004
      **********************************************************************    CPL004
      **                                                                  **    CPL004
      ** SR/#CHKFRQ - Check Frequency Codes                               **    CPL004
      ** ==========                                                       **    CPL004
      ** Parameters:                                                      **    CPL004
      ** ===========                                                      **    CPL004
      **  In : None                                                       **    CPL004
      **                                                                  **    CPL004
      **  Out: None.                                                      **    CPL004
      **                                                                  **    CPL004
      ** Description:                                                     **    CPL004
      ** ============                                                     **    CPL004
      **  Check each Frequency code that is blank for entries on the      **    CPL004
      **    schedule files. Override the value on PF/DEALSDG.             **    CPL004
      **                                                                  **    CPL004
      **********************************************************************    CPL004
                                                                                CPL004
     C     #CHKFRQ       Begsr                                                  CPL004
      *                                                                         CPL004
      ** Check the Interest and Rate Fix Frequencies for entries                CPL004
      **   on the schedule files.                                               CPL004
      ** 1. Our Interest Payment Frequency.                                     CPL004
     C     DUIPFR        IfEq      ' '                                          CPL004
      *                                                                         CPL004
      ** Check the Date Schedule file.                                          CPL004
     C                   Eval      @KDDLNO = DDLNO                              CPL004
     C                   Eval      @KDOTIN = 'U'                                CPL004
     C                   Eval      @KDRCIP = 'P'                                CPL004
     C     @KDTSL        SetLL     DLDTSCR0                               90    CPL004
      *                                                                         CPL004
      ** If an entry exists, override the frequency to "Z".                     CPL004
     C     *In90         IfEq      '1'                                          CPL004
     C                   Eval      DUIPFR  = 'Z'                                CPL004
     C                   Else                                                   CPL004
      *                                                                         CPL004
      ** Otherwise, check the Cashflow Schedule file.                           CPL004
     C                   Eval      @KCDLNO = DDLNO                              CPL004
     C                   Eval      @KCOTIN = 'U'                                CPL004
     C     @KCFSL        SetLL     DLCFSCR0                               90    CPL004
      *                                                                         CPL004
      ** If an entry exists, override the frequency to "C".                     CPL004
     C     *In90         IfEq      '1'                                          CPL004
     C                   Eval      DUIPFR  = 'C'                                CPL004
     C                   EndIf                                                  CPL004
                                                                                CPL004
     C                   EndIf                                                  CPL004
                                                                                CPL004
     C                   EndIf                                                  CPL004
                                                                                CPL004
      ** 2. Our Rate Change Frequency.                                          CPL004
     C     DUICFR        IfEq      ' '                                          CPL004
      *                                                                         CPL004
      ** Check the Date Schedule file.                                          CPL004
     C                   Eval      @KDDLNO = DDLNO                              CPL004
     C                   Eval      @KDOTIN = 'U'                                CPL004
     C                   Eval      @KDRCIP = 'R'                                CPL004
     C     @KDTSL        SetLL     DLDTSCR0                               90    CPL004
      *                                                                         CPL004
      ** If an entry exists, override the frequency to "Z".                     CPL004
     C     *In90         IfEq      '1'                                          CPL004
     C                   Eval      DUICFR  = 'Z'                                CPL004
     C                   EndIf                                                  CPL004
                                                                                CPL004
     C                   EndIf                                                  CPL004
                                                                                CPL004
      ** 3. Their Interest Payment Frequency.                                   CPL004
     C     DTIPFR        IfEq      ' '                                          CPL004
      *                                                                         CPL004
      ** Check the Date Schedule file.                                          CPL004
     C                   Eval      @KDDLNO = DDLNO                              CPL004
     C                   Eval      @KDOTIN = 'T'                                CPL004
     C                   Eval      @KDRCIP = 'P'                                CPL004
     C     @KDTSL        SetLL     DLDTSCR0                               90    CPL004
      *                                                                         CPL004
      ** If an entry exists, override the frequency to "Z".                     CPL004
     C     *In90         IfEq      '1'                                          CPL004
     C                   Eval      DTIPFR  = 'Z'                                CPL004
     C                   Else                                                   CPL004
      *                                                                         CPL004
      ** Otherwise, check the Cashflow Schedule file.                           CPL004
     C                   Eval      @KCDLNO = DDLNO                              CPL004
     C                   Eval      @KCOTIN = 'T'                                CPL004
     C     @KCFSL        SetLL     DLCFSCR0                               90    CPL004
      *                                                                         CPL004
      ** If an entry exists, override the frequency to "C".                     CPL004
     C     *In90         IfEq      '1'                                          CPL004
     C                   Eval      DTIPFR  = 'C'                                CPL004
     C                   EndIf                                                  CPL004
                                                                                CPL004
     C                   EndIf                                                  CPL004
                                                                                CPL004
     C                   EndIf                                                  CPL004
                                                                                CPL004
      ** 4. Their Rate Change Frequency.                                        CPL004
     C     DTICFR        IfEq      ' '                                          CPL004
      *                                                                         CPL004
      ** Check the Date Schedule file.                                          CPL004
     C                   Eval      @KDDLNO = DDLNO                              CPL004
     C                   Eval      @KDOTIN = 'T'                                CPL004
     C                   Eval      @KDRCIP = 'R'                                CPL004
     C     @KDTSL        SetLL     DLDTSCR0                               90    CPL004
      *                                                                         CPL004
      ** If an entry exists, override the frequency to "Z".                     CPL004
     C     *In90         IfEq      '1'                                          CPL004
     C                   Eval      DTICFR  = 'Z'                                CPL004
     C                   EndIf                                                  CPL004
                                                                                CPL004
     C                   EndIf                                                  CPL004
                                                                                CPL004
     C                   Endsr                                                  CPL004
                                                                                CPL004
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

      ** If error in RP1145, set Return Code accordingly.
     C                   If        ReturnCode = *blank
     C                   Eval      ReturnCode = ('ErrRP1145')
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

      *
      ** Key List for LF/DLDTSCL0.                                              CPL004
     C     @KDTSL        KLIST                                                  CPL004
     C                   KFLD                    @KDDLNO                        CPL004
     C                   KFLD                    @KDOTIN                        CPL004
     C                   KFLD                    @KDRCIP                        CPL004
      ** Key List for LF/DLCFSCL0.                                              CPL004
     C     @KCFSL        KLIST                                                  CPL004
     C                   KFLD                    @KCDLNO                        CPL004
     C                   KFLD                    @KCOTIN                        CPL004

     C                   ENDSR
      *****************************************************************
