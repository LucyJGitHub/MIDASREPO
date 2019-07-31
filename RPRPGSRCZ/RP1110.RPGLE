     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Midas-Plato interface pre-proc PF/INTYPD')
      *****************************************************************
      *                                                               *
      *  Meridian DBA Replication                                     *
      *                                                               *
      *  RP1110 - Midas-Plato Interface                               *
      *           Replication Pre-Processing Program for PF/INTYPD.   *
      *                                                               *
      * This program is called as part of the Meridian Replication    *
      *  system for the Midas-Plato Interface.                        *
      *                                                               *   CPL005
      * ****** This will only being run if CPL005 is OFF *******      *   CPL005
      *                                                               *   CPL005
      * For each record on PF/INTYPD, every transaction record for    *
      *   that instrument will be accessed and the following message  *
      *   format will be output to Meridian:                          *
      *                                                               *
      *  INTYPD   - Format of PF/INTYPD received.                     *
      * ->                                                            *
      *¦ FFTRNINS - Format of PF/TRANSD joined with PF/INTYPD         *
      *¦            (Additional PF/INTYPD format if ETO option)       *
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPL005             Date 16Jan01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 177415             Date 22Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPL003  *CREATE    Date 09Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CPL005 - Midas-Plato Real-time Interface.                    *
      *           (Header Box changes only)                           *
      *           This program will be replaced by RP1150 if CPL005   *
      *           is active.                                          *
      *  177415 - Replication performance improvements.               *
      *           Do not close database files by not setting on *INLR.*
      *  CPL003 - Midas-Plato Interface                               *
      *                                                               *
      *****************************************************************
      *  Indicator Usage:                                             *
      *   *IN80 - End of records for key on PF/TRANSD.                *
      *   *INU7 - Error encountered in processing.                    *
      *   *INLR - Last Record - End program.                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     F*
     FINTYP     IF   E           K DISK    PREFIX(I)
     FMARKT     IF   E           K DISK    PREFIX(M)
     FTRANS13   IF   E           K DISK    PREFIX(T)
 
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
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      **   Format for PF/INTYPD
     D INTYPDds      E DS                  EXTNAME(INTYPD)
     D                                     PREFIX(I)
 
      **   Format for PF/INTYPD underlying futures record.
     D INTYPDfu        S                   LIKE(INTYPDds)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D                                     PREFIX(B)
      ** External DS for bank details
 
      **   Format for PF/TRANSD
     D TRANSDds      E DS                  EXTNAME(TRANSD)
     D                                     PREFIX(T)
 
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
      **   Parameters for AOBANKR0
     D   @OPTN         S              7A   INZ(*BLANKS)
     D   @RTCD         S              7A   INZ(*BLANKS)
      **   Parameters for AOHOLS0
     D   @CCY          S              3A   INZ(*BLANKS)
     D   @LOC          S              3A   INZ(*BLANKS)
     D   @DNO          S              5S 0 INZ(*ZEROS)
      **   Output queue name
     D OutQueue2       S                   LIKE(MQSQueue)
      **   Key to PF/INTYPD and PF/TRANSD
     D @KISTT1         S                   LIKE(IISTT) INZ(*BLANKS)
     D @KISTT2         S                   LIKE(IISTT) INZ(*BLANKS)
      **   Key to PF/INTYPD and PF/TRANSD
     D @KMRKT          S                   LIKE(MMRKT) INZ(*BLANKS)
 
     DOutParms         DS
     D   OutData                           LIKE(TransData) INZ(*BLANKS)
     D   OutLen                       4S 0 INZ(*ZERO)
 
     DIntParms         DS
     D   IntData                           LIKE(TransData) INZ(*BLANKS)
     D   IntLen                            LIKE(OutLen)  INZ(*ZERO)
 
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
 
     C* Extract the Instrument Type from the data input.
 
     C                   Eval      @KISTT1 = %subst(TransData:22:5)
 
     C* Access original record on PF/INTYPD.
 
     C     @KISTT1       Chain     INTYPDF                            90
 
      ** If error then perform any special processing and exit
     C                   If        *IN90 <> '0'
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   Reset                   OutParms
     C                   Reset                   IntParms
 
     C* Format the data from PF/INTYPD for Meridian.
 
     C                   Eval      InData   = INTYPDds
     C                   Eval      InDBFile = 'INTYPD    '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
 
     C* Output a message for the record format for PF/INTYPD.
 
     C                   Eval      WrkData  = OutData
     C                   Eval      RAMSGTYPE=('INTYPD_A  ')
     C                   Exsr      #SNDMSG
 
     C* Construct the Instrument portion of the message.
 
     C                   Eval      IntParms = OutParms
 
     C* For ETO Options, access the related underlying futures instrument
 
     C     IFTRF         IfNe      *Blanks
 
     C                   Eval      @KISTT2=@KISTT1
     C                   Eval      %subst(@KISTT2:3:3) = IFTRF
 
     C* Access related underlying futures record on PF/INTYPD.
 
     C     @KISTT2       Chain     INTYPDF                            90
 
      ** If error then perform any special processing and exit
     C                   If        *IN90 <> '0'
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   Reset                   OutParms
 
     C* Format the data from PF/INTYPD for Meridian.
 
     C                   Eval      InData   = INTYPDds
     C                   Eval      InDBFile = 'INTYPD    '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
 
     C* Append the related underlying futures record to the instrument data.
 
     C                   Eval      %subst(IntData:OutLen) = OutData
 
     C                   EndIf
 
      ** Access the Market Details for non-OTC Instruments.
 
     C     IISTI         IfEq      'N'
 
     C                   Reset                   @KMRKT
     C                   Eval      @KMRKT = %subst(IISTT:1:2)
     C     @KMRKT        CHAIN     MARKT                              90
 
      ** If error then perform any special processing and exit
     C                   If        *IN90 <> '0'
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   EndIf
 
     C* Process all transactions for the instrument.
 
     C     @KISTT1       SetLL     TRANSDF
     C     @KISTT1       ReadE     TRANSDF                                80
 
     C     *IN80         DowEq     '0'
 
      ** Use SR/FFDDATE to calculate the value date of the contract.
 
     C     IISTI         IfEq      'N'
 
     C                   CallB     'FFDATE'
     C                   Parm      *Blanks       ReturnCode
     C                   Parm                    FFDAY             5 0
     C                   Parm      ISEDF         FFDATC            7
     C                   Parm      TMTHN         FFMTH             2 0
     C                   Parm      TYRNO         FFYR              2 0
     C                   Parm      MMKLC         FFCCY1            3
     C                   Parm      MMLOC         FFLOC             3
     C                   Parm      IISCY         FFCCY2            3
     C                   Parm      IOTHC         FFCCY3            3
     C                   Parm      BBJDFIN       FFDFIN            1
 
      ** If error then perform any special processing and exit
 
     C                   If        ReturnCode <> *Blanks
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   Eval      TVALD = FFDAY
 
     C                   EndIf
 
     C* Format the data from PF/TRANSD for Meridian.
 
     C                   Eval      InData   = TRANSDds
     C                   Eval      InDBFile = 'TRANSD    '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
 
     C* Output a message for the record format for PF/TRANSD, joined
     C*   with the record format(s) for PF/INTYPD.
 
     C                   Reset                   WrkData
     C                   Eval      WrkData  = OutData
     C                   Eval      %subst(WrkData:OutLen) = IntData
 
     C* Send the message for FFTRNINS.
 
     C                   Eval      RAMSGTYPE=('FFTRNINS_A')
     C                   Exsr      #SNDMSG
 
     C     @KISTT1       ReadE     TRANSDF                                80
     C                   EndDo
 
     C**Call*the Holidays Access Object to close all files left open            177415
     C****by*the calls to PGM/FFDATE.                                           177415
      **********                                                                177415
     C**********         Call      'AOHOLS0'                                    177415
     C**********         Parm      *Blanks       @RTCD                          177415
     C**********         Parm      '*FREE  '     @OPTN                          177415
     C**********         Parm      *Blanks       @CCY                           177415
     C**********         Parm      *Blanks       @LOC                           177415
     C**********         Parm      *Zeros        @DNO                           177415
     C**********         Parm      *Blanks       DSSDY                          177415
 
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
 
      ** If error in RP1110, set Return Code accordingly.
     C                   If        ReturnCode = *blank
     C                   Eval      ReturnCode = ('ErrRP1110')
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
 
      ** Access Bank details via access program
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** If error then perform any special processing and exit
     C                   If        @RTCD <> *blank
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   ENDSR
      *****************************************************************
