     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Midas-Plato interface pre-proc PF/TRADSD')
      *****************************************************************
      *                                                               *
      *  Meridian DBA Replication                                     *
      *                                                               *
      *  RP1130 - Midas-Plato Interface                               *
      *           Replication Pre-Processing Program for PF/TRADSD.   *
      *                                                               *
      * This program is called as part of the Meridian Replication    *
      *  system for the Midas-Plato Interface.                        *
      * For each record on PF/TRADSD, the following message format    *
      *   will be output to Meridian:                                 *
      *                                                               *
      *  SETRDSEC - Format of PF/TRADSD joined with PF/SECTYD and     *
      *             PF/INVTPD.                                        *
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
      *                 CGL031             Date 05Jan04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 12Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 177415             Date 22Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 173883             Date 18Jan00               *
      *                 CPL003  *CREATE    Date 11Jun99               *
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
      *  173883 - Problem with CAC005 switch ON.                      *
      *  CPL003 - Midas-Plato Interface                               *
      *                                                               *
      *****************************************************************
      *  Indicator Usage:                                             *
      *   *IN90 - End of records for key on PF/SECTYD and PF/INVTPD.  *
      *   *INU7 - Error encountered in processing.                    *
      *   *INLR - Last Record - End program.                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     F*
     FTRADS     IF   E           K DISK    PREFIX(T)
     FSECTY     IF   E           K DISK    PREFIX(S)
     FINVTP     IF   E           K DISK    PREFIX(I)
     FSECED     IF   E           K DISK    PREFIX(E)
 
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
 
      **   Format for PF/TRADSD
     D TRADSDds      E DS                  EXTNAME(TRADSD)
     D                                     PREFIX(T)
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
      **   Output queue name
     D OutQueue2       S                   LIKE(MQSQueue)
 
     DOutParms         DS
     D   OutData                           LIKE(TransData) INZ(*BLANKS)
     D   OutLen                       4S 0 INZ(*ZERO)
     DWrkParms         DS
     D   WrkData                           LIKE(TransData) INZ(*BLANKS)
     D   WrkLen                            LIKE(OutLen) INZ(*ZERO)
      **   Key to PF/TRADSD.
     D @KTDRF          S                   LIKE(TTDRF) INZ(*Blanks)
      **   Key to PF/INVTPD.
     D @KCCYI          S                   LIKE(ICCYI) INZ(*Blanks)
     D @KINVT          S                   LIKE(IINVT) INZ(*Blanks)
      **   Key to PF/SECED.
     D @KDSDSN         S                   LIKE(ESDSN) INZ(*Blanks)
     D @KDSDED         S                   LIKE(ESDED) INZ(*Zeros)
     D @KDSDET         S                   LIKE(ESDET) INZ(*Blanks)
 
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
 
     C* Extract the Trade Reference for the data received.
 
     C                   Eval      @KTDRF  = %subst(TransData:22:6)
 
     C* Access original record on PF/TRADSD.
 
     C     @KTDRF        Chain     TRADSDF                            90
 
      ** If error then perform any special processing and exit
     C                   If        *IN90 <> '0'
     C                   Exsr      *PSSR
     C                   EndIf
      *                                                                         173883
     C** If PCA-SE Enhancements present, convert Pseudo Book to User            173883
     C**   Book Code                                                            173883
     C     CAC005        IfEq      'Y'                                          173883
      *                                                                         173883
     C                   CALL      'AOBKPCR0'                                   173883
     C                   PARM      *BLANKS       PRTCD             7            173883
     C                   PARM      '*USER  '     POPTN             7            173883
     C                   PARM                    PBKCD             2            173883
     C                   PARM                    PPRFC             4            173883
     C                   PARM      TTDBK         PPSBK             2            173883
      *                                                                         173883
     C     PRTCD         IFEQ      *BLANKS                                      173883
     C                   MOVEL     PBKCD         TTDBK                          173883
     C                   ENDIF                                                  173883
      *                                                                         173883
     C                   ENDIF                                                  173883
 
     C* Format the data from PF/TRADSD for Meridian.
 
     C                   Eval      InData   = TRADSDds
     C                   Eval      InDBFile = 'TRADSD    '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
 
     C* Contruct the compound messgae format.
 
     C                   Eval      WrkParms = OutParms
 
     C* Access the related record on LF/SECTY.
 
     C     TTDSS         Chain     SECTYDF                            90
 
      ** If error then perform any special processing and exit
     C                   If        *IN90 <> '0'
     C                   Exsr      *PSSR
     C                   EndIf
 
     C***If*PCA-SE*Enhancements*present,*convert*Pseudo*Book*to*User*           173883
     C*****Book*Code*************************************************           173883
     C*****CAC005        IfEq      'Y'                                          173883
      ***********                                                               173883
     C***********        CALL      'AOBKPCR0'                                   173883
     C***********        PARM      *BLANKS       PRTCD             7            173883
     C***********        PARM      '*USER  '     POPTN             7            173883
     C***********        PARM                    PBKCD             2            173883
     C***********        PARM                    PPRFC             4            173883
      ***********        PARM      TTDBK         PPSBK             2            173883
      ***********                                                               173883
     C*****PRTCD         IFEQ      *BLANKS                                      173883
     C***********        MOVEL     PBKCD         TTDBK                          173883
      ***********        ENDIF                                                  173883
      ***********                                                               173883
     C***********        ENDIF                                                  173883
 
     C* If the security is partly paid, get the Partly Paid Price
     C*   applicable for the trade.
     C*
     C     SPPDI         IFEQ      'Y'
     C*
     C                   MoveL     TTDSS         @KDSDSN
     C                   Z-Add     TTDVD         @KDSDED
     C                   MoveL     'PP'          @KDSDET
 
     C     @KSECED       SetGt     SECED
 
     C                   MoveL     '0'           *IN88
     C     *IN88         DouEq     '1'
     C                   ReadP     SECED                                  88
 
     C     *IN88         IfEq      '0'
     C     ESDSN         AndEq     @KDSDSN
 
     C     ESDET         IfEq      'CP'
     C     ESDET         OrEq      'PP'
     C                   MoveL     '1'           *IN88
 
     C     IPROT         IfEq      '2'
     C     IPROT         OrEq      '4'
     C     IPROT         OrEq      '7'
     C                   Z-Add     ESDTA         SCPDP
     C                   Else
     C                   Z-Add     ESDTP         SCPDP
     C                   Z-Add     100.00        SSFPP
     C                   EndIf
 
     C                   EndIf
 
     C                   Else
 
     C     ESDSN         IfNe      @KDSDSN
     C                   MoveL     '1'           *IN88
     C                   EndIf
 
     C                   EndIf
 
     C                   EndDo
 
     C                   EndIf
 
     C* Format the data from PF/SECTYD for Meridian.
 
     C                   Eval      InData   = SECTYDds
     C                   Eval      InDBFile = 'SECTYD    '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
 
     C* Contruct the compound messgae format.
 
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
 
     C* Send the message for SETRDSEC
 
     C                   Eval      RAMSGTYPE=('SETRDSEC_A')
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
 
      ** If error in RP1130, set Return Code accordingly.
     C                   If        ReturnCode = *blank
     C                   Eval      ReturnCode = ('ErrRP1130')
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
 
     C* Key list for LF/SECED.
     C     @KSECED       KLIST
     C                   KFLD                    @KDSDSN
     C                   KFLD                    @KDSDED
     C                   KFLD                    @KDSDET
 
     C**  Access Switchable features file for PCA-SE Enhancement CAC005
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CAC005'      @SARD             6
      *
     C     @RTCD         IfEq      *BLANK
     C                   MOVE      'Y'           CAC005            1
     C                   EndIf
 
     C                   ENDSR
      *****************************************************************
