     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Midas-Plato interface pre-proc PF/DEALSDC')   *
      *****************************************************************
      *                                                               *
      *  Meridian DBA Replication                                     *
      *                                                               *
      *  RP1120 - Midas-Plato Interface                               *
      *           Replication Pre-Processing Program for PF/DEALSDC   *
      *           and PF/DEAMSDI.                                     *
      *                                                               *
      * This program is called as part of the Meridian Replication    *
      *  system for the Midas-Plato Interface.                        *
      * For each record on PF/DEALSDC or PF/DEAMSDI, the following    *
      *   message formats will be output to Meridian:                 *
      *                                                               *
      *  DEALSDC  - Format of PF/DEALSDC joined with Ins/Amd Ind="I"  *
      * ->                                                            *
      *¦ DLAMDDLC - Format of PF/DEAMSDI joined with PF/DEALSDC       *
      * --                                                            *
      *  DEALSDC  - Format of PF/DEALSDC joined with Ins/Amd Ind="A"  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 15Feb17               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
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
      *                 CGL014             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 177415             Date 22Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPL003  *CREATE    Date 09Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  177415 - Replication performance improvements.               *
      *           Do not close database files by not setting on *INLR.*
      *  CPL003 - Midas-Plato Interface                               *
      *                                                               *
      *****************************************************************
      *  Indicator Usage:                                             *
      *   *IN80 - End of records for key on PF/DEAMSDI.               *
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
     F**********                           IGNORE(DEALSDDF:DEALSDEF)            177415
     F**********                           IGNORE(DEALSDFF:DEALSDGF)            177415
     F**********                           PREFIX(D)                            177415
     FDEALS     IF   E           K DISK    PREFIX(D)                            177415
     FDEAMS     IF   E           K DISK    IGNORE(DEAMSDHF:DEAMSDJF)
     F                                     PREFIX(A)
 
      /EJECT
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      * Following /COPY is the procedure prototype for the Format routine
      /COPY RPCPYSRC,RPFMTPPF
 
      ** The following /COPY contains various standard declares
     C***/COPY*RPCPYSRC,Std_Dcl                                                             MD030364
     C/COPY RPCPYSRC,STD_DCL                                                                MD030364
 
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
 
      **   Format for PF/DEALSDC
     D DEALSDCds     E DS                  EXTNAME(DEALSDC)
     D                                     PREFIX(D)
 
      **   Format for PF/DEAMSDI
     D DEAMSDIds     E DS                  EXTNAME(DEAMSDI)
     D                                     PREFIX(A)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Key to PF/DEAMSDI.
     D@KDEAMSds        DS
     D @KDLNOA                 1      6A
     D @KDLNO                  1      6S 0
     D @KVDAT          S                   LIKE(AVDAT)
 
      ** Parameters
      **   Parameters for ProcFormat
     D   InData        S                   LIKE(TransData) INZ(*Blanks)
     D   InDBFile      S             10A   INZ(*Blanks)
     D   InDecSep      S              1A   INZ('.')
     D   InShwPosSn    S              1A   INZ('N')
      **   Output queue name
     D OutQueue2       S                   LIKE(MQSQueue)
 
     DOutParms         DS
     D   OutData                           LIKE(TransData) INZ(*BLANKS)
     D   OutLen                       4S 0 INZ(*ZERO)
 
     DSavParms         DS
     D   SavData                           LIKE(TransData) INZ(*BLANKS)
     D   SavLen                            LIKE(OutLen) INZ(*ZERO)
 
     DWrkParms         DS
     D   WrkData                           LIKE(TransData) INZ(*BLANKS)
     D   WrkLen                            LIKE(OutLen) INZ(*ZERO)
 
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
 
     C* Output a message for the record format received for PF/DEALSDC,
     C*  joined to an "Insert/Amend Indicator" set to "I".
 
     C* Extract the Deal Number from the data input.
 
     C                   Eval      @KDLNOA = %subst(TransData:24:6)
 
     C* Access original record on PF/DEALSDC.
 
     C     @KDLNO        Chain     DEALSDCF                           90
 
      ** If error then perform any special processing and exit
     C                   If        *IN90 <> '0'
     C                   Exsr      *PSSR
     C                   EndIf
 
     C* Access the latest Deal Amendment to get the Value Date.
     C                   Eval      @KDLNO   = DDLNO
     C                   Eval      @KVDAT   = *HIVAL
     C     @KDEAMS       SetGt     DEAMSDIF
     C                   ReadP     DEAMSDIF                               90
 
     C* If record found for deal, set the Deal Amendment Value Date to be
     C*  the latest date, rather than the first date.
     C     *IN90         IfEq      '0'
     C     ADLNO         AndEq     @KDLNO
     C                   Eval      DDAVD    = AVDAT
     C                   EndIf
 
     C* Format the data from PF/DEALSDC for Meridian.
 
     C                   Eval      InData   = DEALSDCds
     C                   Eval      InDBFile = 'DEALSDC   '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
 
     C* Save the formatted record from DEALSDC.
 
     C                   Eval      SavParms = OutParms
 
     C* Append the Action Code indicator at the end of the record.
 
     C                   Reset                   WrkData
     C                   Eval      WrkData  = OutData
     C                   Eval      %subst(WrkData:OutLen) = 'I'
 
     C* Send the message for DEALSDC.
 
     C                   Eval      RAMSGTYPE=('DEALSDC_A')
     C                   Exsr      #SNDMSG
 
     C* Read all Deal Amendments for the deal being processed.
 
     C     @KDLNO        SetLL     DEAMSDIF
     C     @KDLNO        ReadE     DEAMSDIF                               80
 
     C     *IN80         DowEq     '0'
 
     C* Format the data from PF/DEAMSDI for Meridian.
 
     C                   Eval      InData   = DEAMSDIds
     C                   Eval      InDBFile = 'DEAMSDI   '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
 
     C* Output a message for the record format for PF/DEAMSDI, joined
     C* with the record format received for PF/DEALSDC.
 
     C                   Reset                   WrkData
     C                   Eval      WrkData  = SavData
     C                   Eval      %subst(WrkData:SavLen) = OutData
 
     C* Send the message for DLAMDDLC.
 
     C                   Eval      RAMSGTYPE=('DLAMDDLC_A')
     C                   Exsr      #SNDMSG
 
     C     @KDLNO        ReadE     DEAMS                                  80
     C                   EndDo
 
     C* Output a message for the record format received for PF/DEALSDC,
     C*  joined to an "Insert/Amend Indicator" set to "A".
     C* Append the Action Code indicator at the end of the record.
 
     C                   Reset                   WrkData
     C                   Eval      WrkData  = SavData
     C                   Eval      %subst(WrkData:SavLen) = 'A'
 
     C* Send the message for DEALSDC.
 
     C                   Eval      RAMSGTYPE=('DEALSDC_A')
     C                   Exsr      #SNDMSG
 
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
 
      ** If error in RP1120, set Return Code accordingly.
     C                   If        ReturnCode = *blank
     C                   Eval      ReturnCode = ('ErrRP1120')
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
 
     C                   ENDSR
 
      ** Key List to LF/DEAMS.
     C     @KDEAMS       KLIST
     C                   KFLD                    @KDLNO
     C                   KFLD                    @KVDAT
      *****************************************************************
