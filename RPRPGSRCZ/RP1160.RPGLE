     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Midas-Plato interface pre-proc PF/PRICSD')
      *****************************************************************
      *                                                               *
      *  Meridian DBA Replication                                     *
      *                                                               *
      *  RP1160 - Midas-Plato Interface                               *
      *           Replication Pre-Processing Program for PF/PRICSD.   *
      *                                                               *
      * This program is called as part of the Meridian Replication    *
      *  system for the Midas-Plato Interface.                        *
      * For each record on PF/PRICSD, the following message format    *
      *   will be output to Meridian:                                 *
      *                                                               *
      *  FFPRCINS - Format of PF/PRICSD joined with PF/INTYPD         *
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
      * Midas DBA 3.03 -----------------------------------------------*
      *                 177415             Date 22Mar00               *
      *                 CPL003  *CREATE    Date 21Mar00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
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
     FPRICS1    IF   E           K DISK    PREFIX(P)
     FINTYP     IF   E           K DISK    PREFIX(I)
     FMARKT     IF   E           K DISK    PREFIX(M)
 
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
      **   Format for PF/PRICSD
     D PRICSDds      E DS                  EXTNAME(PRICSD)
     D                                     PREFIX(P)
      **   Format for PF/MARKTD
     D MARKTDds      E DS                  EXTNAME(MARKTD)
     D                                     PREFIX(M)
 
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
     D   @OPTN         S              7A   INZ(*Blanks)
     D   @RTCD         S              7A   INZ(*Blanks)
      **   Parameters for AOHOLS0
     D   @CCY          S              3A   INZ(*Blanks)
     D   @LOC          S              3A   INZ(*Blanks)
     D   @DNO          S              5S 0 INZ(*Zeros)
      **   Output queue name
     D OutQueue2       S                   LIKE(MQSQueue)
      **   Key to PF/PRICS1
     D@KPRICS1         DS
     D @KISTT                              LIKE(PISTT) INZ(*Blanks)
     D @KPCAL                              LIKE(PPCAL) INZ(*Blanks)
     D @KSTRP                              LIKE(PSTRP) INZ(*Zeros)
      **   Strike Price (Formatted)
     D@KSTRPds         DS
     D @KSTRPA                 1     17    INZ(*Blanks)
     D @KSTRPI                 2      8    INZ(*Blanks)
     D @KSTRPD                10     17    INZ(*Blanks)
      **   Year and Month (Formatted)
     D@KYRMNds         DS
     D @KYRNOA                 1      4    INZ(*Blanks)
     D @KYRNO                  3      4S 0 INZ(*Zeros)
     D @KMTHNA                 5      8    INZ(*Blanks)
     D @KMTHN                  7      8S 0 INZ(*Zeros)
      **   Key to PF/MARKTD.
     D @KMRKT          S                   LIKE(MMRKT) INZ(*BLANKS)
 
     DOutParms         DS
     D   OutData                           LIKE(TransData) INZ(*BLANKS)
     D   OutLen                       4S 0 INZ(*ZERO)
 
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
 
     C* Extract the Price Details from the data input.
 
     C                   Eval      @KISTT  = %subst(TransData:22:5)
     C                   Eval      @KYRNOA = %subst(TransData:27:4)
     C                   Eval      @KMTHNA = %subst(TransData:31:4)
     C                   Eval      @KPCAL  = %subst(TransData:35:1)
     C                   Eval      @KSTRPA = %subst(TransData:36:17)
 
     C* Re-format the Strike Price as a numeric value.
 
     C                   Movel     @KSTRPI       @KSTRP
     C                   Move      @KSTRPD       @KSTRP
 
     C* Access related record on PF/PRICSD.
 
     C     @KPRICS       Chain     PRICSDF                            90
 
      ** If error then perform any special processing and exit
     C                   If        *IN90 <> '0'
     C                   Exsr      *PSSR
     C                   EndIf
 
     C* Format the data from PF/PRICSD for Meridian.
 
     C                   Eval      InData   = PRICSDds
     C                   Eval      InDBFile = 'PRICSD    '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
     C* Construct the Price portion of the message.
 
     C                   Eval      WrkParms = OutParms
 
     C* Access related record on PF/INTYPD.
 
     C     @KISTT        Chain     INTYPDF                            90
 
      ** If error then perform any special processing and exit
     C                   If        *IN90 <> '0'
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Access the Market Details.
 
     C     IISTI         IfEq      'N'
 
     C                   Reset                   @KMRKT
     C                   Eval      @KMRKT = %subst(IISTT:1:2)
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
     C                   Parm      PMTHN         FFMTH             2 0
     C                   Parm      PYRNO         FFYR              2 0
     C                   Parm      MMKLC         FFCCY1            3
     C                   Parm      MMLOC         FFLOC             3
     C                   Parm      IISCY         FFCCY2            3
     C                   Parm      IOTHC         FFCCY3            3
     C                   Parm      BBJDFIN       FFDFIN            1
 
      ** If error then perform any special processing and exit
 
     C                   If        *IN90 <> '0' or ReturnCode <> *Blanks
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   Eval      IFTDT = FFDAY
 
     C                   EndIf
 
     C                   Reset                   OutParms
 
     C* Format the data from PF/INTYPD for Meridian.
 
     C                   Eval      InData   = INTYPDds
     C                   Eval      InDBFile = 'INTYPD    '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
 
     C* Append the related Instrument record to the Price data.
 
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
 
     C* Send the message for FFPRCINS.
 
     C                   Eval      RAMSGTYPE=('FFPRCINS_A')
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
 
      ** If error in PL1010, set Return Code accordingly.
     C                   If        ReturnCode = *blank
     C                   Eval      ReturnCode = ('ErrPL1160')
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
 
      ** Define Key List for LF/PRICS1
     C     @KPRICS       Klist
     C                   Kfld                    @KISTT
     C                   Kfld                    @KYRNO
     C                   Kfld                    @KMTHN
     C                   Kfld                    @KPCAL
     C                   Kfld                    @KSTRP
 
     C                   ENDSR
      *****************************************************************
