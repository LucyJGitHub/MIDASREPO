     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Midas-Plato interface pre-proc PF/TRANSD')
      *****************************************************************
      *                                                               *
      *  Meridian DBA Replication                                     *
      *                                                               *
      *  RP1150 - Midas-Plato Interface                               *
      *           Replication Pre-Processing Program for PF/TRANSD.   *
      *                                                               *
      * This program is called as part of the Meridian Replication    *
      *  system for the Midas-Plato Interface.                        *
      * For each record on PF/TRANSD, the following message format    *
      *   will be output to Meridian:                                 *
      *                                                               *
      *  FFTRNINS - Format of PF/TRANSD joined with PF/INTYPD         *
      *             (Additional PF/INTYPD format if ETO option)       *
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
      *                 CPL005             Date 23Jan01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 177415             Date 22Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPL003  *CREATE    Date 14Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CPL005 - Midas-Plato Real-time Interface                     *
      *  177415 - Replication performance improvements.               *
      *           Do not close database files by not setting on *INLR.*
      *  CPL003 - Midas-Plato Interface                               *
      *                                                               *
      *****************************************************************
      *  Indicator Usage:                                             *
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
     FTRANS2    IF   E           K DISK    PREFIX(T)
 
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
 
      **   Format for PF/SDBANKPD
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D                                     PREFIX(B)
      **   Format for PF/INTYPD
     D INTYPDds      E DS                  EXTNAME(INTYPD)
     D                                     PREFIX(I)
      **   Format for PF/TRANSD
     D TRANSDds      E DS                  EXTNAME(TRANSD)
     D                                     PREFIX(T)
      **   Format for PF/MARKTD
     D MARKTDds      E DS                  EXTNAME(MARKTD)
     D                                     PREFIX(D)
 
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
     D@KTRANSD         DS
     D @KTNBRA                 1      6A   INZ(*BLANKS)
     D @KTNBR                  1      6S 0 INZ(*ZEROS)
     D @KISTT                              LIKE(IISTT) INZ(*BLANKS)
      **   Key to PF/MARKTD.
     D @KMRKT          S                   LIKE(MMRKT) INZ(*BLANKS)
 
     DOutParms         DS
     D   OutData                           LIKE(TransData) INZ(*BLANKS)
     D   OutLen                       4S 0 INZ(*ZERO)
 
     DWrkParms         DS
     D   WrkData                           LIKE(TransData) INZ(*BLANKS)
     D   WrkLen                            LIKE(OutLen) INZ(*ZERO)
                                                                                              CPL005
     D CPL005          S              1A                                                      CPL005
     D @Op_Code        S              1A                                                      CPL005
     D @SARD           S              6A                                                      CPL005
 
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
 
     C* Extract the Transaction Number from the data input.
 
     C                   Eval      @KTNBRA = %subst(TransData:24:6)
 
     C* Access original record on PF/TRANSD.
 
     C     @KTNBR        Chain     TRANSDF                            90
 
      ** If error then perform any special processing and exit
     C                   If        *IN90 <> '0'
     C                   Exsr      *PSSR
     C                   EndIf
 
     C* Set up the Instrument Type.
 
     C                   Eval      @KISTT  = TISTT
 
     C* Access related record on PF/INTYPD.
 
     C     @KISTT        Chain     INTYPDF                            90
 
      ** If error then perform any special processing and exit
     C                   If        *IN90 <> '0'
     C                   Exsr      *PSSR
     C                   EndIf
      *                                                                                       CPL005
      ** If Real-time interface is present and the operation code from                        CPL005
      ** the input date is 'I' or 'A' then output 'INTYPD_A' message.                         CPL005
      *                                                                                       CPL005
     C                   IF        CPL005 = 'Y'                                               CPL005
     C                   EVAL      @Op_Code = %SUBST(TransData:1:1)                           CPL005
                                                                                              CPL005
     C                   IF        @Op_Code = 'I' or @Op_Code = 'A'                           CPL005
                                                                                              CPL005
     C                   Reset                   OutParms                                     CPL005
                                                                                              CPL005
     C* Format the data from PF/INTYPD for Meridian.                                          CPL005
                                                                                              CPL005
     C                   Eval      InData   = INTYPDds                                        CPL005
     C                   Eval      InDBFile = 'INTYPD    '                                    CPL005
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:                     CPL005
     C                                                   InDecSep:InShwPosSn)                 CPL005
                                                                                              CPL005
     C* Output a message for the record format for PF/INTYPD.                                 CPL005
                                                                                              CPL005
     C                   Eval      WrkData  = OutData                                         CPL005
     C                   Eval      RAMSGTYPE=('INTYPD_A  ')                                   CPL005
     C                   Exsr      #SNDMSG                                                    CPL005
                                                                                              CPL005
     C                   ENDIF                                                                CPL005
                                                                                              CPL005
     C                   ENDIF                                                                CPL005
 
      ** Access the Market Details.
 
     C     IISTI         IfEq      'N'
 
     C                   Reset                   @KMRKT
     C                   Eval      @KMRKT = %subst(TISTT:1:2)
     C     @KMRKT        CHAIN     MARKT                              90
 
      ** If error then perform any special processing and exit
     C                   If        *IN90 <> '0'
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Use SR/FFDDATE to calculate the value date of the contract.
 
     C                   CallB     'FFDATE'                               90
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
 
     C                   If        *IN90 <> '0' or ReturnCode <> *Blanks
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   Eval      TVALD = FFDAY
 
     C                   EndIf
 
     C                   Reset                   OutParms
 
     C* Format the data from PF/INTYPD for Meridian.
 
     C                   Eval      InData   = TRANSDds
     C                   Eval      InDBFile = 'TRANSD    '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
 
     C* Construct the Instrument portion of the message.
 
     C                   Eval      WrkParms = OutParms
 
     C                   Reset                   OutParms
 
     C* Format the data from PF/INTYPD for Meridian.
 
     C                   Eval      InData   = INTYPDds
     C                   Eval      InDBFile = 'INTYPD    '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
 
     C* Append the related Instrument record to the Transaction data.
 
     C                   Eval      %subst(WrkData:WrkLen) = OutData
     C                   Eval      WrkLen   = WrkLen + OutLen
 
     C* For ETO Options, access the related underlying futures instrument
 
     C     IFTRF         IfNe      *Blanks
 
     C                   Eval      %subst(@KISTT:3:3) = IFTRF
 
     C* Access related underlying futures record on PF/INTYPD.
 
     C     @KISTT        Chain     INTYPDF                            90
 
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
 
     C                   Eval      %subst(WrkData:(WrkLen-1)) = OutData
 
     C                   EndIf
 
     C* Send the message for FFTRNINS.
 
     C                   Eval      RAMSGTYPE=('FFTRNINS_A')
     C                   Exsr      #SNDMSG
 
     C* Call the Holidays Access Object to close all files left open
     C*   by the calls to PGM/FFDATE.
 
     C                   Call      'AOHOLS0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*FREE  '     @OPTN
     C                   Parm      *Blanks       @CCY
     C                   Parm      *Blanks       @LOC
     C                   Parm      *Zeros        @DNO
     C                   Parm      *Blanks       DSSDY
 
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
 
      ** If error in PL1010, set Return Code accordingly.
     C                   If        ReturnCode = *blank
     C                   Eval      ReturnCode = ('ErrPL1010')
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
      *                                                                                       CPL005
      ** Check if Midas-Plato Real-time Interface is on.                                      CPL005
      *                                                                                       CPL005
     C                   CALLB     'AOSARDR0'                                                 CPL005
     C                   PARM      *BLANKS       @RTCD                                        CPL005
     C                   PARM      '*VERIFY'     @OPTN                                        CPL005
     C                   PARM      'CPL005'      @SARD                                        CPL005
      *                                                                                       CPL005
     C     @RTCD         IFEQ      *BLANK                                                     CPL005
     C                   MOVE      'Y'           CPL005                                       CPL005
     C                   ELSE                                                                 CPL005
     C                   MOVE      'N'           CPL005                                       CPL005
     C                   ENDIF                                                                CPL005
 
     C                   ENDSR
      *****************************************************************
