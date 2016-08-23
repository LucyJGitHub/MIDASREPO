     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MS Midas/CAS communications          *MODULE')   *
      *****************************************************************
      *                                                               *
      *  Midas SWIFT Direct link : Midas/CAS interface                *
      *                                                               *
      *  MS8010M - Midas/CAS communications                           *
      *                                                               *
      *  Function:  This program effects communications between       *
      *             Midas and a SWIFT CBT using the Common            *
      *             Application Server (CAS).                         *
      *                                                               *
      *             It is used for both incoming and outgoing         *
      *             messages. If used to send outgoing messages       *
      *             a server job (MS_M2A_SRV) should be submitted     *
      *             for each instance to format them.                 *
      *                                                               *
      *  Called By: MSC8010 - Midas/CAS communications                *
      *                                                               *
      *  Calls    : MS8000M - CASmf API wrapper functions             *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. AR976772           Date 23May12               *
      *  Prev Amend No. CSW212             Date 03May12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CTI004             Date 12Apr04               *
      *                 CRE008             Date 23May02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186477             Date 17Nov00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 Patch A Fix Update 3 --------------------------*
      *                 184427             DATE 02Oct00               *
      *                 184013             DATE 20Sep00               *
      *                 174459             DATE 31Jan00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 146340             DATE 29Oct98               *
      *                 140532             Date 11Aug98               *
      *                 134831             Date  7Apr98               *
      *                 134491             Date  5Apr98               *
      *                 128989             Date 12Mar98               *
      *                 125554             Date 19NOV97               *
      *                 123750             Date 01JUL97               *
      *                 119392             Date 17JUN97               *
      *                 118481             Date 28MAY97               *
      *                 CSW008 *CREATE     Date 16JUL96               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR976772 - Value date century is not populated for all types *
      *  CSW212 - SWIFT 2012 Changes                                  *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CTI004 - MidasPlus-TI Integration Enhancements               *
      *           Routing Swift Messages                              *
      *   CRE008 - Cash Management                                    *
      *            Here, add type 103 in TABTYP to extract            *
      *            date and amount in MSIXI2PD                        *
      *  CDL008 - Continuous Linked Settlement (Recompile MGOREFPD)   *
      *  186477 - MS8010M crashes when receiving SWIFT2000 MT350s     *
      *  184427 - Add MT340s and MT360s                               *
      *  184013 - Swift 2000 get correct date format from 30V         *
      *  174459 - Only increment last sequence on conversation fail   *
      *  146340 - Set up century field for year 2000.                 *
      *  140532   Crashes if incoming message contains :20C: instead  *
      *           of :20:. Format of :20C: is :20C::CCCC//TRN...      *
      *  134831 - Add sender's number to trace                        *
      *  134491 - Set on PDE flag for recovery                        *
      *  128989 - Use last successful session & sequence number + 1   *
      *  125554   Data in fields :32 , :34 , :19 , :30 , :25 being    *
      *           corrupted due to incorrect start position in array. *
      *  123750 - SWIFT 1997 message changes                          *
      *            - Change of format for MT300; access value date    *
      *              in :30V: for reference generation.               *
      *  119392 - Do not process ACKs and NAKs for non-Midas messages *
      *  118481 - Midas/CAS interface changes for CASmf v2.1          *
      *            - CUSCFG changed from PF to member of source       *
      *              file DAT. Change environment variable defn.      *
      *  CSW008 - Midas/CAS interface                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Notes:                                                       *
      *  ------                                                       *
      *                                                               *
      *    o  This module uses the CASmf API to exchange messages,    *
      *       ACKs and NAKs with the CBT.                             *
      *    o  The CASmf API is made available to RPG programs by      *
      *       MS8000M, the CASmf API wrapper.                         *
      *    o  This module will be bound with MS8000M to form the      *
      *       communications program MS8010P. The CASmf is            *
      *       bound with this code using a binding directory.         *
      *       The program creation (bind) can be done using CRTOBJ    *
      *       on source MSPGMSRC mbr(MS8010P).                        *
      *    o  API return codes are decoded by table TABCD/TABNAR,     *
      *       which is based on cusapi.h                              *
      *                                                               *
      *****************************************************************
      /EJECT
     FMSMAPIL0  UF   E           K disk    infsr(srfile)
     FMGOREFL0  UF   E           K disk    infsr(srfile)
     F                                     commit
     FMGOMSGPD  IF   E           K disk    infsr(srfile)
     FMSMSI2L9  IF   E           K disk    infsr(srfile)
     F                                     rename(msmsi2d0:msmsi2d9)
     FSDBRCHL0  IF   E           K disk    infsr(srfile)
     FSDCUSTL7  IF   E           K disk    infsr(srfile)
     FMSMSI2PD  O    E           K disk    infsr(srfile)
     F                                     commit
     FMSIXI2PD  O    E           K disk    infsr(srfile)
     F                                     commit
     FMS8010AU  O    E             printer infsr(srfile)
     F                                     oflind(*in66)
     F                                     usropn
      /EJECT
      /COPY MSCPYSRC,CUSAPIDEF
      /COPY MSCPYSRC,SRERRD
     D cpy@            S             80    dim(1) ctdata perrcd(1)
      ** Array containing Copyright statement
      *
     D*tabtyp**********S              3    dim(15) ctdata perrcd(1)             184427
     D*tabcas**********S              1    dim(15) alt(tabtyp)                  184427
     D*tabtyp**********S              3    dim(20) ctdata perrcd(1)      184427 CRE008
     D*tabcas**********S              1    dim(20) alt(tabtyp)           184427 CRE008
     D*tabtyp**********S              3    dim(21) ctdata perrcd(1)                    CRE008 CSW212
     D*tabcas**********S              1    dim(21) alt(tabtyp)                         CRE008 CSW212
     D tabtyp          S              3    dim(23) ctdata perrcd(1)                           CSW212
     D tabcas          S              1    dim(23) alt(tabtyp)                                CSW212
      ** Message type specific processes
      *
     D tabty2          S              3    dim(1) ctdata perrcd(1)                            CSW212
     D tabamc          S             10    dim(1) alt(tabty2)                                 CSW212
      ** Message tag and qualifier for amount/currency                                        CSW212
      *                                                                                       CSW212
     D tabty3          S              3    dim(1) ctdata perrcd(1)                            CSW212
     D tabdat          S             10    dim(1) alt(tabty3)                                 CSW212
      ** Message tag and qualifier for value date                                             CSW212
      *                                                                                       CSW212
     D tabmonn         S              2    dim(12) ctdata perrcd(1)
     D tabmona         S              3    dim(12) alt(tabmonn)
      ** Month code by month number (eg. 01 JAN)
      *
     D ar1             S              4    dim(14) ctdata perrcd(1)                           CSW209
     D ar2             S              1    dim(14) alt(ar1)                                   CSW209
      ** Escape Sequence Translation Array                                                    CSW209
      *                                                                                       CSW209
     D br@midas        S              3    dim(99)
     D br@swift        S             11    dim(99)
      ** Midas branch code v SWIFT branch code
      *
     D                 DS
     D  MTAG                   1      5
     D  @WL1                   5      5
      ** Message tag structure
      *
     D w@b2dta         DS            46
     D  w@mtpy                 1      3
     D  w@96n                  1      2
     D  tme                    4      7
     D  MIR                    8     35
     D  w@sndad               14     21
     D  w@sndbr               23     25
     D  MODE                  36     41  0
     D  MOTM                  42     45  0
     D  w@mpry                46     46
      ** Split up Block 2 of incoming message
      *
     D                 DS
     D  MOR                    1     28
     D  w@mord                 1      6
     D  w@dstad                7     14
     D  w@dstbr               16     18
     D  w@morr                 7     28
      ** Message Ouput Reference (MOR)
      *
     D                 DS
     D  A8BTID                 1     12
     D  w@brad                 1      8
     D  w@brbr                10     12
      ** Split up branch TID
      *
     D                 DS
     D  w@mode                 1      6
     D  w@year                 1      2
     D  w@month                3      4
     D  w@day                  5      6
      ** Message output date
      *
     D                 DS
     D  w@latm                 1      6  0
     D  w@motm                 1      4
     D  w@zz                   5      6    inz('00')
      ** Message output time and last action time
      *
     D                 DS
     D  k@clikey               1     12
     D  k@cliad                1      8
     D  k@clibr                9     11
      ** Key for access to Customer Details
      *
     D                 DS
     D  w@abn                  1      3  0
     D  w@aba                  1      3
      ** Convert abort type to alpha
      *
     D dsfdy         E DS                  extname(DSFDY)
      ** Data Structures used by access objects
      *
     D sdbank        E DS                  extname(SDBANKPD)
      ** Bank details data area
      *
     D sdmmod        E DS                  extname(SDMMODPD)
      ** Bank details data area
      *
     D medta         E DS                  extname(MEDTA)
      ** Message Management data area
      *
     D  msstat       E DS                  extname(MSSTAT)
     Dren@zz53       E                     extfld(ZZ053)                                      140532
      ** Midas/SWIFT Direct Link status data area
      *
     D  sdstat       E DS                  extname(SDSTAT)
     Dren@mode       E                     extfld(MODE)
      ** SDSTAT for system prefix
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CTI004
      ** DS for SC Switchable Features                                                        CTI004
                                                                                              CTI004
     D                 DS
     D  q@dqm                  1  12050
     D  q@sndref               1     50
     D  q@msgbuf              51  12050
      ** Data queue entry (message)
      *
     D                 DS
     D**q@dqc******************1  12050                                                       118481
     D  q@dqc                  1     50
     D  q@prompt               1     50
      ** Data queue entry (control)
      *
      /SPACE 2
     Dp@rc             S              4B 0
     Dp@apdu           S              9B 0
     Dp@recover        S              9B 0
     Dp@reason         S              9B 0
     Dp@acknak         S              9B 0
     Dp@rstatus        S              9B 0
     Dp@dtatyp         S              9B 0
     Dp@format         S              9B 0
     Dp@dup            S              9B 0
     Dp@sess           S              9B 0
     Dp@seqn           S              9B 0
     Dp@sessx          S              9B 0
     Dp@seqnx          S              9B 0
     Dlsess            S              9B 0                                                    128989
     Dlseqn            S              9B 0                                                    128989
     Dp@force          S              9B 0
     Dp@wait           S              9B 0
     Dp@success        S              9B 0
     Dp@ab_type        S              9B 0
      ** API short (4B) and int (9B) parameters
      *
     D                 DS
     D  p@msgtyp               1      4
     D  p@msgtyp1              1      3
     Dp@trcf           S             11
     Dp@sender         S             20
     Dp@api_mapi       S             27
     Dp@orisrf         S             50
     Dp@sndref         S             50
     Dp@rtext          S          12000
     Dp@msgbuf         S          12000
      ** API string parameters
      *
     D*@env1***********S             20    inz('DATTOP=CASMF/')                               118481
     D*@env2***********S             20    inz('CUSCFG=CASMF/CUSCFG')                         118481
     Dw@env1           S             20    inz('DATTOP=CASMF/DAT(')
     Dw@env2           S             24    inz('CUSCFG=CASMF/DAT(CUSCFG)')
      ** Environment variables for CASmf
      *
     D                 DS
     D  w@tx3                  1      4    inz('}{4:')
     D  w@cr                   5      5    inz(x'0d')
     D  w@lf                   6      6    inz(x'25')
     D  w@crlf                 5      6
     D  w@stag                 7      9                                                       125554
     D  w@scan                 5      9                                                       125554
     D  txt3                   1      6
     Dw@null           S              1    inz(x'00')
     Dw@dly            S             14    inz('DLYJOB DLY(10)')
      ** Control codes and fixed texts
      *
     Dcsw209           S              1    inz('N')                                           CSW209
      ** CSW209 switch                                                                        CSW209
      *                                                                                       CSW209
     Dw@c1             S              5  0 inz(*zero)                                         CSW209
     Dw@c2             S              5  0 inz(*zero)                                         CSW209
     Dw@c3             S              5  0 inz(*zero)                                         CSW209
     Dw@chr            S              1    inz(*blank)                                        CSW209
     Dz                S              2  0 inz(*zero)                                         CSW209
     Dw@f1             S          12000    inz(*blank)                                        CSW209
     Dw@f2             S          12000    inz(*blank)                                        CSW209
     Dw@f3             S          12000    inz(*blank)                                        CSW209
     Dw@f4             S          12000    inz(*blank)                                        CSW209
      ** Work field for the processing of Escape Translation                                  CSW209
     D digits          C                   '0123456789'                                       CSW212
                                                                                              CTI004
      ** Declared variables for enhancement CTI004                                            CTI004
                                                                                              CTI004
     D PMSGBUF         S           9999                                                       CTI004
     D PMTPY           S              3                                                       CTI004
     D POKFLG          S              1                                                       CTI004
     D CTI004          S              1                                                       CTI004
     D PRTCD           S              7                                                       CTI004
     D POPTN           S              7                                                       CTI004
     D PSARD           S              6                                                       CTI004
                                                                                              CTI004
      /EJECT
      *****************************************************************
      *  Index to Subroutines                                         *
      *                                                               *
      *  sr_init       : Initialise program and session               *
      *  sr_analyse    : Analyse API return codes (and trace)         *
      *  sr_in         : Get incoming messages and write to database  *
      *  sr_esctr      : Process Escape Sequence Translations         *                       CSW209
      *  sr_out        : Format and transmit outgoing messages        *
      *  sr_msg        : Write incoming message to database           *
      *  sr_ix         : Generate index (reference) record            *
      *  sr_typa       : Process incoming messages of type A          *
      *  sr_typb       : Process incoming messages of type B          *
      *  sr_typc       : Process incoming messages of type C          *
      *  sr_typd       : Process incoming messages of type D          *
      *  sr_rpt        : Process report (ACK / NAK)                   *
      *  sr_trash      : Process unexpected data                      *
      *  sr_dcon       : Disconnect from CBT                          *
      *  sr_open       : Open session with CBT                        *
      *  sr_abort      : Attempt to recover aborted session           *
      *  *PSSR         : Standard program exception error routine     *
      *****************************************************************
      /EJECT
      *
      ** Set up copyright parameter
     C                   movea     cpy@          cpy2@            80
      *
     C     *entry        plist
     C                   parm                    p@lmapid         26
     C                   parm                    p@dtqm           10
     C                   parm                    p@dtqc           10
     C                   parm                    p@io              1
      *
      ** Push routine
     C                   z-add     1             Q
     C                   movel     'mainline'    @STK(Q)
      *
      ** Perform initial process
     C                   exsr      sr_init
      *
      ** If session opened successfully...
     C     w@open        ifeq      'Y'
      *
      ** execute process for incoming or outgoing messages
     C     p@io          ifeq      'I'
     C                   exsr      sr_in
     C                   else
     C                   exsr      sr_out
     C                   endif
      *
     C                   endif
      *
      ** Attempt clean disconnection
     C                   exsr      sr_dcon
      *
     C                   seton                                        LR
      /EJECT
      **********************************************************************
      * sr_analyse     : Analyse return code information and trace if      *
      * ----------       requested by user.                                *
      *                                                                    *
      * Called by      : sr_init, sr_in, sr_out, sr_dcon                   *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_analyse    begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_analyse'  @STK(Q)
      *
      ** Lookup API return code, and indicate if not found
     C     p@rc          lookup    tabcd         tabnar                   55
     C     *in55         ifeq      *off
     C                   movel(p)  'NOT_FOUND'   w@rcnar          20
     C                   else
     C                   movel(p)  tabnar        w@rcnar
     C                   endif
      *
      ** Check whether trace requested. If it is, write trace information
      ** to report.
     C                   in        msstat
     C     TRACF         ifeq      'T'
      *
      ** If spool file not already open, open it now.
     C     w@prtopn      ifne      'Y'
     C                   movel     'Y'           w@prtopn          1
     C                   open      ms8010au
     C                   write     ms8010f1
     C                   endif
      *
      ** Check for overflow and rewrite headings if necessary.
     C     *in66         ifeq      *on
     C                   movel     *off          *in66
     C                   write     ms8010f1
     C                   endif
      *
      ** Set up standard details and write to report
     C                   time                    PR@TI
     C                   movel(p)  w@rcnar       PR@RC
     C                   movel(p)  t@apifn       PR@FN
     C                   write     ms8010t1
      *
      ** If data in buffer, write this too
     C     t@tdat        ifne      *blank
     C                   movel(p)  t@tdat        PR@DT
     C                   write     ms8010t2
     C                   clear                   t@tdat          100
     C                   endif
      *
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_out         : Format and transmit outgoing messages             *
      * ------                                                             *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : MC8000M - MC_snd_NDF                              *
      *                            MC_rcv_data                             *
      *                                                                    *
      **********************************************************************
      *
     C     sr_out        begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_out'      @STK(Q)
      *
      ** Prompt server for first message (if recovery required request
      ** failed message first).
     C     MCRECO        ifeq      'Y'
     C                   movel(p)  MCRSTR        q@prompt
     C                   else
     C                   movel(p)  '*NEXT'       q@prompt
     C                   endif
     C                   call      'QSNDDTAQ'    q@snddtaq
      *
      ** DoUntil termination requested or an abormal condition detected
     C     *in01         doueq     *on
     C     w@abnormal    oreq      'Y'
      *
      ** Check for termination request
     C                   shtdn                                        01
      *
      ** If termination not requested prompt server to prepare next message
      ** while we process the current one
     C     *in01         ifeq      *off
     C                   movel(p)  '*NEXT'       q@prompt
     C                   call      'QSNDDTAQ'    q@snddtaq
     C                   endif
      *
      ** Pick up current message from data queue
     C                   call      'QRCVDTAQ'    q@rcvdtaq
      *
      ** If message available attempt to send it
     C     q@sndref      ifne      '*NONE'
     C     q@sndref      andne     '*ERROR'
      *
      ** Access PENDing message on file to lock
     C                   movel     q@sndref      w@trn            16
     C     w@trn         chain     mgorefl0                           50
      *
      ** Set up message details in API fields
     C                   movel     q@msgbuf      p@msgbuf
     C     q@sndref      cat       w@null:0      p@sndref
      *
      ** Call API function to send NDF SWIFT
     C                   callb     'MC_snd_NDF'
     C                   parm                    p@sndref
     C                   parm                    p@msgbuf
     C                   parm                    p@sessx
     C                   parm      0             p@seqnx
     C                   parm      0             p@rc
      *
      ** If send successful, get Logical REPly (LREP)
     C                   movel(p)  'MC_snd_***'  t@apifn          30
     C                   movel(p)  p@msgbuf      t@tdat
     C                   movel(p)  p@sndref      PR@RF                                        134831
     C                   exsr      sr_analyse
      *
     C     w@rcnar       ifeq      'SUCCESS'
      *
     C                   callb     'MC_rcv_data'
     C                   parm      60            p@wait
     C                   parm      0             p@dtatyp
     C                   parm      w@null        p@msgbuf
     C                   parm      w@null        p@sndref
     C                   parm      0             p@sess
     C                   parm      0             p@seqn
     C                   parm      0             p@dup
     C                   parm      0             p@format
     C                   parm      0             p@ab_type
     C                   parm      w@null        p@sender
     C                   parm      w@null        p@msgtyp
     C                   parm      0             p@rstatus
     C                   parm      w@null        p@rtext
     C                   parm      w@null        p@orisrf
     C                   parm      0             p@reason
     C                   parm      0             p@acknak
     C                   parm      0             p@rc
      *
     C                   movel(p)  'MC_rcv_data' t@apifn
     C                   movel(p)  p@msgbuf      t@tdat
     C                   movel(p)  p@orisrf      PR@RF                                        134831
     C                   exsr      sr_analyse
      *
      ** If return code indicates session no longer open, Alliance may
      ** have issued abort due to invalid message, so attempt recovery
     C     w@rcnar       ifeq      'NOT_OPEN'
     C                   exsr      sr_abort
     C                   endif
      *
     C                   endif
      *
      ** If send fails, or fail to get logical reply, log recovery details,
      ** indicate abnormal end and disconnect
     C     w@rcnar       ifne      'SUCCESS'
     C     p@dtatyp      orne      2
      *
     C     p@lmapid      chain     MSMAPIL0                           51
     C     *in51         ifeq      *off
     C                   z-add     p@sessx       MCSESS
     C                   z-add     p@seqnx       MCSEQN
     C                   z-add     lsess         MCSESS                                       128989
     C                   z-add     lseqn         MCSEQN                                       128989
     C                   movel(p)  TRNO          MCRSTR
     C                   movel     'Y'           MCRECO
     C                   update    msmapid0
     C                   endif
      *
     C                   movel     'Y'           w@abnormal
     C                   movel     'CASmf API'   w0file
     C                   movel     'MEM6001'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   movel     'Send message'w0key
     C                   z-add     101           w0ernb
      *
     C                   else
      *
      ** Save successful session & sequence numbers                                           128989
     C                   move      p@sessx       lsess                                        128989
     C                   move      p@seqnx       lseqn                                        128989
      *
      ** If this was recovery run, recovery was a success so reset
      ** details
     C     MCRECO        ifeq      'Y'
     C     p@lmapid      chain     msmapil0                           50
     C     *in50         ifeq      *off
     C                   clear                   MCSESS
     C                   clear                   MCSEQN
     C                   clear                   MCRSTR
     C                   movel     'N'           MCRECO
     C                   update    msmapid0
     C                   endif
     C                   endif
      *
     C                   endif
      *
      ** Update message status: RECO -> failed on this attempt (set for
      ** recovery); TRAN -> Tx/ed OK; EFMT -> error in format (continue)
     C     w@abnormal    ifeq      'Y'
     C                   movel     'RECO'        MGST
     C                   movel     'Y'           MPDE                                         134491
     C                   else
     C     p@acknak      ifeq      1
     C                   movel     '3'           MGSG
     C                   movel     'TRAN'        MGST
     C                   else
     C                   movel     '4'           MGSG
     C                   movel     'EFMT'        MGST
     C                   endif
     C                   endif
     C                   movel     BJMRDT        LADT
     C                   TIME                    LATM
     C                   update    mgorefd0
     C                   commit
      *
      ** else (if no messages to send) wait for prompt/time-out
     C                   else
     C                   callb     'MSC8011M'
     C                   endif
     C                   enddo
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_in          : Get incoming messages and write to database       *
      * -----                                                              *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls            MC8000M - MC_rcv_data                             *
      *                            MC_snd_LREP                             *
      *                                                                    *
      *                  sr_msg                                            *
      *                  sr_rpt                                            *
      *                  sr_trash                                          *
      *                  sr_esctr                                          *                  CSW209
      *                                                                    *
      **********************************************************************
      *
     C     sr_in         begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_in'       @STK(Q)
      *
      ** Access incoming data until termination requested by user,
      ** Abort requested by CBT or API error.
     C     *in01         doueq     *on
     C     p@dtatyp      oreq      7
     C     p@dtatyp      oreq      6
     C     w@rcnar       orne      'SUCCESS'
     C     w@rcnar       andne     'TIMEOUT'
      *
      ** Attempt to receive data (wait up to 20 seconds before time-out)
     C                   callb     'MC_rcv_data'
     C                   parm      20            p@wait
     C                   parm      0             p@dtatyp
     C                   parm      w@null        p@msgbuf
     C                   parm      w@null        p@sndref
     C                   parm      0             p@sess
     C                   parm      0             p@seqn
     C                   parm      0             p@dup
     C                   parm      0             p@format
     C                   parm      0             p@ab_type
     C                   parm      w@null        p@sender
     C                   parm      w@null        p@msgtyp
     C                   parm      0             p@rstatus
     C                   parm      w@null        p@rtext
     C                   parm      w@null        p@orisrf
     C                   parm      0             p@reason
     C                   parm      0             p@acknak
     C                   parm      0             p@rc
      *
      ** If data received, update database
     C                   movel(p)  'MC_rcv_data' t@apifn
     C     p@dtatyp      ifeq      1
      *                                                                                       CSW209
      ** Scan message for Escape Sequence Translation                                         CSW209
     C     csw209        ifeq      'Y'                                                        CSW209
     C                   eval      w@f1 = p@msgbuf                                            CSW209
     C                   exsr      sr_esctr                                                   CSW209
     C                   eval      p@msgbuf = w@f1                                            CSW209
     C                   endif                                                                CSW209
      *                                                                                       CSW209
     C                   movel(p)  p@msgbuf      t@tdat
     C                   endif
     C     p@dtatyp      ifeq      3
      *                                                                                       CSW209
      ** Scan message for Escape Sequence Translation                                         CSW209
     C     csw209        ifeq      'Y'                                                        CSW209
     C                   eval      w@f1 = p@rtext                                             CSW209
     C                   exsr      sr_esctr                                                   CSW209
     C                   eval      p@rtext = w@f1                                             CSW209
     C                   endif                                                                CSW209
      *                                                                                       CSW209
     C                   movel(p)  p@rtext       t@tdat
     C                   endif
     C                   movel(p)  p@orisrf      PR@RF                                        134831
     C                   exsr      sr_analyse
     C     w@rcnar       ifeq      'SUCCESS'
     C     p@dtatyp      andle     3
      *
      ** Perform approriate process for Message, Report (ACK / NAK)
      ** or other (unexpected)
     C     p@dtatyp      caseq     1             sr_msg
     C     p@dtatyp      caseq     3             sr_rpt
     C                   cas                     sr_trash
     C                   endcs
      *
      ** Send Logical REPly (LREP)
     C                   callb     'MC_snd_LREP'
     C                   parm      0             p@rc
      *
     C                   movel(p)  'MC_snd_LREP' t@apifn
     C                   exsr      sr_analyse
     C                   endif
      *
      ** Check whether termination has been requested
     C                   shtdn                                        01
      *
     C                   enddo
      *
      ** If receive fails, or unable to send LREP indicate abnormal end
      ** and disconnect
     C     w@rcnar       ifne      'SUCCESS'
     C     w@rcnar       andne     'TIMEOUT'
     C     w@rcnar       andne     'NOT_OPEN'
     C                   movel     'Y'           w@abnormal
     C                   movel     'CASmf API'   w0file
     C                   movel     'MEM6001'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   movel     'Rcv message' w0key
     C                   z-add     102           w0ernb
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************                  CSW209
      * sr_esctr       : Process Escape Sequence Translations              *                  CSW209
      * ------                                                             *                  CSW209
      *                                                                    *                  CSW209
      * Called by      : sr_in                                             *                  CSW209
      *                                                                    *                  CSW209
      * Calls          :                                                   *                  CSW209
      *                                                                    *                  CSW209
      **********************************************************************                  CSW209
      *                                                                                       CSW209
     C     sr_esctr      begsr                                                                CSW209
      *                                                                                       CSW209
      ** Push subroutine                                                                      CSW209
     C                   add       1             Q                                            CSW209
     C                   movel     'sr_esctr'    @STK(Q)                                      CSW209
      *                                                                                       CSW209
     C                   eval      z = 1                                                      CSW209
      *                                                                                       CSW209
     C                   dow       z < 15                                                     CSW209
      *                                                                                       CSW209
     C     ar1(z)        scan      w@f1          w@c1                     89                  CSW209
     C                   dow       *in89 = *on                                                CSW209
      *                                                                                       CSW209
     C                   eval      w@chr = ar2(z)                                             CSW209
     C                   if        w@c1 = 1                                                   CSW209
      *                                                                                       CSW209
     C                   eval      w@c3 = w@c1 + 4                                            CSW209
     C                   subst     w@f1:w@c3     w@f3                                         CSW209
     C     w@chr         cat       w@f3:0        w@f4                                         CSW209
     C                   else                                                                 CSW209
      *                                                                                       CSW209
     C                   eval      w@c2 = w@c1 - 1                                            CSW209
     C     w@c2          subst     w@f1          w@f2                                         CSW209
     C                   eval      w@c3 = w@c1 + 4                                            CSW209
     C                   subst     w@f1:w@c3     w@f3                                         CSW209
     C                   move      *blanks       temp              1                          CSW209
     C                   move      w@c2          pos               5 0                        CSW209
     C                   eval      temp = %subst(w@f1:pos)                                    CSW209
     C                   move      0             ctr               1 0                        CSW209
     C                   dow       temp = ' '                                                 CSW209
     C                   add       1             ctr                                          CSW209
     C                   sub       1             pos                                          CSW209
     C                   eval      temp=%subst(w@f1:pos)                                      CSW209
     C                   enddo                                                                CSW209
     C     w@f2          cat       w@chr:0       w@f2                                         CSW209
     C     w@f2          cat       w@f3:0        w@f4                                         CSW209
     C                   endif                                                                CSW209
      *                                                                                       CSW209
     C                   eval      w@f1 = w@f4                                                CSW209
     C                   eval      w@f2 = *blanks                                             CSW209
     C                   eval      w@f3 = *blanks                                             CSW209
     C                   eval      w@f4 = *blanks                                             CSW209
     C     ar1(z)        scan      w@f1          w@c1                     89                  CSW209
     C                   enddo                                                                CSW209
      *                                                                                       CSW209
     C                   eval      z = z + 1                                                  CSW209
     C                   enddo                                                                CSW209
      *                                                                                       CSW209
      ** Pop subroutine                                                                       CSW209
     C                   clear                   @STK(Q)                                      CSW209
     C                   sub       1             Q                                            CSW209
     C                   endsr                                                                CSW209
      /EJECT                                                                                  CSW209
      **********************************************************************
      * sr_msg         : Write incoming message to database                *
      * ------                                                             *
      *                                                                    *
      * Called by      : sr_in                                             *
      *                                                                    *
      * Calls          : sr_ix                                             *
      *                                                                    *
      **********************************************************************
      *
     C     sr_msg        begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_msg'      @STK(Q)
      *
      ** Clear message data file formats
     C                   clear                   msmsi2d0
     C                   clear                   msixi2d0
      *
      ** Set up Message Input Reference, and check for duplication
      ** (w@btdta splits up block {2: - see 'D' spec)
     C     '{2:O'        scan      p@msgbuf      w@1               7 0
     C                   add       4             w@1
     C     46            subst     p@msgbuf:w@1  w@b2dta
     C                   movel     w@mpry        MPRY
     C                   movel     w@mtpy        MTPY
      *                                                                                       146340
      ** Set up Century field                                                                 146340
     C                   movel     MODE          cent              2                          146340
     C     cent          iflt      '72'                                                       146340
     C                   move      '20'          MODEC                                        146340
     C                   else                                                                 146340
     C                   move      '19'          MODEC                                        146340
     C                   endif                                                                146340
      *
     C     MIR           setll     msmsi2d9                               60
      *
      ** If message is not a duplicate and is of a recognised type update
      ** database
     C     *in60         ifeq      *off
     C     w@mtpy        andge     '100'
     C     w@mtpy        andle     '999'
     C     w@96n         andne     '96'
      *
      ** Set up the MOR date from the incoming date
     C                   move      MODE          w@mord
      *
      ** Locate Block {1: of the message for the remaining
      ** components of the MOR
     C     '{1:'         scan      p@msgbuf      w@1
     C                   add       6             w@1
     C     22            subst     p@msgbuf:w@1  w@morr
      *
      ** Create message index
     C                   exsr      sr_ix
      *
      ** Set message-processed flag
     C                   movel     'Y'           MSPF
      *
      ** Write all data records to message data file
     C                   z-add     1             w@1
     C     256           subst     p@msgbuf      MDTA
     C     MDTA          downe     *blanks
     C                   write     msmsi2d0
     C                   add       256           w@1
     C     256           subst     p@msgbuf:w@1  MDTA
     C                   enddo
      *
      ** Commit transaction (message) : all data + index
     C                   commit
      *
      ** Prompt Incoming Message Management
     C                   callb     'MEC1024M'                           9090
     C                   parm      *blanks       p@rtcd            7
      *
      ** Update received network information
     C     *dtaara       define                  medta
     C     *lock         in        medta
     C                   movel     MOR           DAMOR
     C                   movel     MIR           DAMIR
     C                   out       medta
      *
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_ix          : Generate index (reference) record for incoming    *
      * -----            message.                                          *
      *                                                                    *
      * Called by      : sr_msg                                            *
      *                                                                    *
      * Calls          : sr_typa                                           *
      *                  sr_typb                                           *
      *                  sr_typc                                           *
      *                  sr_typd                                           *
      *                  sr_type                                           *                  CSW212
      *                                                                    *
      **********************************************************************
      *
     C     sr_ix         begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_ix'       @STK(Q)
      *
      ** Attempt to match destination address with branch address details
      ** from Branch Codes file to determine Midas branch.
     C                   movel     w@dstad       w@try            11
     C                   move      w@dstbr       w@try
     C                   z-add     1             w@b
     C     w@try         lookup    br@swift(w@b)                          80
     C     *in80         ifeq      *on
     C                   movel     br@midas(w@b) BRCA
     C                   endif
      *
      ** Attempt to locate Midas customer number: if found, store 'suppress
      ** download to AutoRecs II' flag.
     C                   move      w@sndad       k@cliad
     C                   move      w@sndbr       k@clibr
     C                   clear                   w@ssdl            1
     C     k@clikey      chain     sdcustl7                           81
     C     *in81         ifeq      *on
     C     k@clibr       andeq     'XXX'
     C                   clear                   k@clibr
     C     k@clikey      chain     sdcustl7                           81
     C                   endif
     C     *in81         ifeq      *off
     C                   move      BBCUST        CNUM
     C                   move      BBSSDL        w@ssdl
     C                   endif
     C                   move      k@clikey      STID
      *
      ** Locate TRN
     C*****':20:'******* scan      p@msgbuf      w@1                                          140532
     C     ':20:'        scan      p@msgbuf      w@1                      65                  140532
     C     *in65         ifeq      *off                                                       140532
     C     ':20C:'       scan      p@msgbuf      w@1                      65                  140532
     C                   add       8             w@1                                          140532
     C                   endif                                                                140532
      *
      ** Scan for the end of the TRN
     C     w@crlf        scan      p@msgbuf:w@1  w@2               7 0
      *
      ** Calculate the length of the TRN
     C                   add       4             w@1
     C     w@2           sub       w@1           w@ln              7 0
      *
      ** Move the TRN into the reference record field
     C                   clear                   w@trno           16
     C     w@ln          subst     p@msgbuf:w@1  w@trno
      *
      ** Determine message type, and process appropriately
     C     MTPY          lookup    tabtyp        tabcas                   82
     C     *in82         ifeq      *on
     C     tabcas        caseq     'A'           sr_typa
     C     tabcas        caseq     'B'           sr_typb
     C     tabcas        caseq     'C'           sr_typc
     C     tabcas        caseq     'D'           sr_typd
     C     tabcas        caseq     'E'           sr_type                                      CSW212
     C                   end
     C                   else
     C                   clear                   FD25
     C                   clear                   SVDT
     C                   clear                   AMTS
     C                   clear                   CCY
     C                   endif
      *
      ** Perform AutoRecs II processing if module is switched on
     C     BGAURC        ifeq      'Y'
      *
      ** If message is statement (940, 950) and 'suppress download to
      ** AutoRecs II' is not set for customer, set up download details.
     C     MTPY          ifeq      '940'
     C     w@ssdl        andne     'Y'
     C     MTPY          oreq      '950'
     C     w@ssdl        andne     'Y'
     C                   TIME                    R3STIM
     C                   movel     'A'           R3RPTS
     C                   z-add     BJRDNB        R3SDAT
     C                   movel     ##JOB         R3LJOB
     C                   movel     ##USR         R3LUSR
     C                   movel     ##JNO         R3LJNO
     C                   endif
      *
     C                   endif
      *
      ** Output record to MSIXI2PD
     C                   move      w@trno        TRNO
                                                                                              CTI004
      ** IF CTI004 is installed, check message type                                           CTI004
                                                                                              CTI004
     C                   IF        CTI004 =  'Y'                                              CTI004
     C                   CALL      'MS6200'                                                   CTI004
     C                   PARM      MTPY          PMTPY                                        CTI004
     C                   PARM      p@rtext       PMSGBUF                                      CTI004
     C                   PARM      ' '           POKFLG                                       CTI004
                                                                                              CTI004
     C                   IF        POKFLG = 'Y'                                               CTI004
     C                   EVAL      IMPF = 'P'                                                 CTI004
     C                   EVAL      LSTS = 'T'                                                 CTI004
     C                   ENDIF                                                                CTI004
                                                                                              CTI004
     C                   ENDIF                                                                CTI004
                                                                                              CTI004
     C                   write     msixi2d0
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_typa        : Process incoming messages of type A: 100, 200,    *
      * -------          202, 300, 320, 324, 330, 900, 910.                *
      *                  600.                                              *                  CSW212
      *                                                                    *
      * Called by      : sr_ix                                             *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_typa       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_typa'     @STK(Q)
      *
      ** No field :25:
     C                   clear                   FD25
      *                                                                                       123750
      ** If message is post-1997 MT300 extract value date from field :30V:                    123750
      ** (Date is CCYYMMDD format; use offset of 7 to extract YYMMDD.)                        123750
      ** As above for post-2000 MT320, MT330                                                  184013
      ** As above for MT360, MT361, MT362                                                     184427
     C     MTPY          ifeq      '300'                                                      123750
     C     MTPY          oreq      '320'                                                      184013
     C     MTPY          oreq      '330'                                                      184013
     C     MTPY          oreq      '360'                                                      184427
     C     MTPY          oreq      '361'                                                      184427
     C     MTPY          oreq      '362'                                                      184427
     C     ':30V:'       scan      p@msgbuf      w@1                      83                  123750
     C                   endif                                                                123750
      *                                                                                       184427
      ** If message is MT340 or MT341 extract value date from field :30F:                     184427
      ** (Date is CCYYMMDD format; use offset of 7 to extract YYMMDD.)                        184427
     C     MTPY          ifeq      '340'                                                      184427
     C     MTPY          oreq      '341'                                                      184427
     C     ':30F:'       scan      p@msgbuf      w@1                      83                  184427
     C                   endif                                                                184427
      *                                                                                       123750
     C     MTPY          ifeq      '300'                                                      123750
     C     *in83         andeq     *on                                                        123750
     C     MTPY          oreq      '320'                                                      184013
     C     *in83         andeq     *on                                                        184013
     C     MTPY          oreq      '330'                                                      184013
     C     *in83         andeq     *on                                                        184013
     C     MTPY          oreq      '340'                                                      184427
     C     *in83         andeq     *on                                                        184427
     C     MTPY          oreq      '341'                                                      184427
     C     *in83         andeq     *on                                                        184427
     C     MTPY          oreq      '360'                                                      184427
     C     *in83         andeq     *on                                                        184427
     C     MTPY          oreq      '361'                                                      184427
     C     *in83         andeq     *on                                                        184427
     C     MTPY          oreq      '362'                                                      184427
     C     *in83         andeq     *on                                                        184427
     C                   add       7             w@1                                          123750
     C     6             subst     p@msgbuf:w@1  SVDT                                         123750
     C     MTPY          ifeq      '362'                                                      184427
     C     ':32M:'       scan      p@msgbuf      w@1                                          184427
     C                   else                                                                 184427
     C     ':32B:'       scan      p@msgbuf      w@1                                          123750
     C                   end                                                                  184427
     C                   add       5             w@1                                          123750
     C                   else                                                                 123750
                                                                                              CSW212
     C     MTPY          ifeq      '600'                                                      CSW212
     C                   movel     ':34'         w@stag                                       CSW212
     C                   else                                                                 CSW212
      *
      ** Find field :32a:
     C*****':32'******** scan      p@msgbuf      w@1                                          125554
     C                   movel     ':32'         w@stag                                       125554
     C                   endif                                                                CSW212
     C     w@scan        scan      p@msgbuf      w@1                                          125554
     C                   add       2             w@1                                          125554
      *
      ** Extract value date
     C                   add       5             w@1
     C     6             subst     p@msgbuf:w@1  SVDT
      *
      ** Extract currency
     C                   add       6             w@1
     C                   endif                                                                123750
      *                                                                                     AR976772
      ** Extract value date century                                                         AR976772
      *                                                                                     AR976772
     C     2             subst     SVDT:1        w@vdyy            2                        AR976772
     C     w@vdyy        iflt      '72'                                                     AR976772
     C                   movel     '20'          SVDTC                                      AR976772
     C                   else                                                               AR976772
     C                   movel     '19'          SVDTC                                      AR976772
     C                   endif                                                              AR976772
     C     3             subst     p@msgbuf:w@1  CCY
      *
      ** Extract amount
     C                   clear                   AMTS
     C                   add       3             w@1
     C     w@crlf        scan      p@msgbuf:w@1  w@2
     C     w@2           sub       w@1           w@ln
     C     w@ln          subst     p@msgbuf:w@1  AMTS
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_typb        : Process incoming messages of type B: 201, 203.    *
      * -------                                                            *
      *                                                                    *
      * Called by      : sr_ix                                             *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_typb       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_typb'     @STK(Q)
      *
      ** No field :25:
     C                   clear                   FD25
      *
      *
      ** Find field :19: and extract amount
     C*****':19'******** scan      p@msgbuf      w@1                                          125554
     C                   movel     ':19'         w@stag                                       125554
     C     w@scan        scan      p@msgbuf      w@1                                          125554
     C                   add       2             w@1                                          125554
     C*                                                                                       125554
     C                   clear                   AMTS
     C                   add       4             w@1
     C     w@crlf        scan      p@msgbuf:w@1  w@2
     C     w@2           sub       w@1           w@ln
     C     w@ln          subst     p@msgbuf:w@1  AMTS
      *
      ** Find field :30: and extract value date
     C*****':30'******** scan      p@msgbuf      w@1                                          125554
     C                   movel     ':30'         w@stag                                       125554
     C     w@scan        scan      p@msgbuf      w@1                                          125554
     C                   add       2             w@1                                          125554
     C*                                                                                       125554
     C                   add       4             w@1
     C     6             subst     p@msgbuf:w@1  SVDT
      *
      ** Find field :32: and extract currency
     C*****':32'******** scan      p@msgbuf      w@1                                          125554
     C                   movel     ':32'         w@stag                                       125554
     C     w@scan        scan      p@msgbuf      w@1                                          125554
     C                   add       2             w@1                                          125554
     C*                                                                                       125554
     C                   add       4             w@1
     C     3             subst     p@msgbuf:w@1  CCY
      *                                                                                     AR976772
      ** Extract value date century                                                         AR976772
      *                                                                                     AR976772
     C     2             subst     SVDT:1        w@vdyy                                     AR976772
     C     w@vdyy        iflt      '72'                                                     AR976772
     C                   movel     '20'          SVDTC                                      AR976772
     C                   else                                                               AR976772
     C                   movel     '19'          SVDTC                                      AR976772
     C                   endif                                                              AR976772
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_typc        : Process incoming messages of type C: 950, 940.    *
      * -------                                                            *
      *                                                                    *
      * Called by      : sr_ix                                             *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_typc       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_typc'     @STK(Q)
      *
      ** Find field :25: and extract account details
     C                   clear                   FD25
     C*****':25'******** scan      p@msgbuf      w@1                                          125554
     C                   movel     ':25'         w@stag                                       125554
     C     w@scan        scan      p@msgbuf      w@1                                          125554
     C                   add       2             w@1                                          125554
     C*                                                                                       125554
     C                   clear                   AMTS
     C                   add       4             w@1
     C     w@crlf        scan      p@msgbuf:w@1  w@2
     C     w@2           sub       w@1           w@ln
     C     w@ln          subst     p@msgbuf:w@1  FD25
      *
      ** Clear remaining details
     C                   clear                   SVDT
     C                   clear                   AMTS
     C                   clear                   CCY
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_typd        : Process incoming messages of type D: 350.         *
      * -------                                                            *
      *                                                                    *
      * Called by      : sr_ix                                             *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_typd       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_typd'     @STK(Q)
      *
      ** No field :25:
     C                   clear                   FD25
      *
      ** Extract value date from field :30V:                                                  184013
      ** (Date is CCYYMMDD format; use offset of 7 to extract YYMMDD.)                        184013
      *                                                                                       184013
     C     ':30V:'       scan      p@msgbuf      w@1                      83                  184013
      *                                                                                       184013
     C     *in83         ifeq      *on                                                        184013
     C                   add       7             w@1                                          184013
     C     6             subst     p@msgbuf:w@1  SVDT                                         184013
     C     ':34B:'       scan      p@msgbuf      w@1                                          184013
     C                   add       5             w@1                                          184013
     C                   else                                                                 184013
      *
      ** Find field :34P:
     C*****':34'******** scan      p@msgbuf      w@1                                          125554
     C                   movel     ':34'         w@stag                                       125554
     C*****w@scan********scan      p@msgbuf:w@1  w@1                                    125554186477
     C     w@scan        scan      p@msgbuf      w@1                                          186477
     C                   add       2             w@1                                          125554
      *
      ** Extract value date
     C                   add       5             w@1
     C     6             subst     p@msgbuf:w@1  SVDT
      *
      ** Extract currency
     C                   add       6             w@1
     C                   endif                                                                184013
     C     3             subst     p@msgbuf:w@1  CCY
      *
      ** Extract amount
     C                   clear                   AMTS
     C                   add       3             w@1
     C     w@crlf        scan      p@msgbuf:w@1  w@2
     C     w@2           sub       w@1           w@ln
     C     w@ln          subst     p@msgbuf:w@1  AMTS
      *                                                                                     AR976772
      ** Extract value date century                                                         AR976772
      *                                                                                     AR976772
     C     2             subst     SVDT:1        w@vdyy                                     AR976772
     C     w@vdyy        iflt      '72'                                                     AR976772
     C                   movel     '20'          SVDTC                                      AR976772
     C                   else                                                               AR976772
     C                   movel     '19'          SVDTC                                      AR976772
     C                   endif                                                              AR976772
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************                  CSW212
      * sr_type        : Process incoming messages of type E: 370.         *                  CSW212
      * -------                                                            *                  CSW212
      *                                                                    *                  CSW212
      * Called by      : sr_ix                                             *                  CSW212
      * Calls          : None                                              *                  CSW212
      *                                                                    *                  CSW212
      **********************************************************************                  CSW212
                                                                                              CSW212
     C     sr_type       BEGSR                                                                CSW212
                                                                                              CSW212
     C                   add       1             Q                                            CSW212
     C                   movel     'sr_type'     @STK(Q)                                      CSW212
                                                                                              CSW212
      ** Check for field :19A:                                                                CSW212
                                                                                              CSW212
     C     MTPY          lookup    tabty2        tabamc                   82                  CSW212
                                                                                              CSW212
     C     *in82         ifeq      *on                                                        CSW212
     C     tabamc        scan      p@msgbuf      w@1                      83                  CSW212
     C                   else                                                                 CSW212
     C     ':19A:'       scan      p@msgbuf      w@1                      83                  CSW212
     C                   endif                                                                CSW212
                                                                                              CSW212
      ** Extract Currency and Amount                                                          CSW212
                                                                                              CSW212
     C     *in83         ifeq      *on                                                        CSW212
     C                   add       12            w@1                                          CSW212
     C                   z-add     0             t@1               7 0                        CSW212
     C     w@1           add       3             t@1                                          CSW212
     C                   movel     *BLANKS       w@testn           1                          CSW212
     C                   subst     p@msgbuf:t@1  w@testn                                      CSW212
     C     digits        check     w@testn                                84                  CSW212
     C     *in84         ifeq      *on                                                        CSW212
     C                   add       1             w@1                                          CSW212
     C                   endif                                                                CSW212
                                                                                              CSW212
     C     3             subst     p@msgbuf:w@1  CCY                                          CSW212
     C                   add       3             w@1                                          CSW212
                                                                                              CSW212
     C                   clear                   AMTS                                         CSW212
     C     w@crlf        scan      p@msgbuf:w@1  w@2                                          CSW212
     C     w@2           sub       w@1           w@ln                                         CSW212
     C     w@ln          subst     p@msgbuf:w@1  AMTS                                         CSW212
     C                   endif                                                                CSW212
                                                                                              CSW212
      ** Check for field :98A:                                                                CSW212
                                                                                              CSW212
     C     MTPY          LOOKUP    tabty3        tabdat                   82                  CSW212
                                                                                              CSW212
     C     *in82         ifeq      *on                                                        CSW212
     C     tabdat        scan      p@msgbuf      w@1                      83                  CSW212
     C                   else                                                                 CSW212
     C     ':98A:'       scan      p@msgbuf      w@1                      83                  CSW212
     C                   endif                                                                CSW212
                                                                                              CSW212
      ** Extract Value date                                                                   CSW212
                                                                                              CSW212
     C     *in83         ifeq      *on                                                        CSW212
     C                   add       12            w@1                                          CSW212
     C     2             subst     p@msgbuf:w@1  SVDTC                                        CSW212
     C                   add       2             w@1                                          CSW212
     C     6             subst     p@msgbuf:w@1  SVDT                                         CSW212
     C                   endif                                                                CSW212
                                                                                              CSW212
     C                   clear                   FD25                                         CSW212
                                                                                              CSW212
     C                   clear                   @STK(Q)                                      CSW212
     C                   sub       1             Q                                            CSW212
     C                   endsr                                                                CSW212
      **********************************************************************                  CSW212
      /EJECT                                                                                  CSW212
      **********************************************************************
      * sr_rpt         : Process Report (ACK / NAK)                        *
      * ------                                                             *
      *                                                                    *
      * Called by      : sr_in                                             *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_rpt        begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_rpt'      @STK(Q)
      *
      ** Clear message data file format
     C                   clear                   msmsi2d0
      *
      ** Access reference record for this message using Original Sender's
      ** Reference (excluding null termination)
     C     w@null        scan      p@orisrf      w@1
     C                   sub       1             w@1
      *
      ** Skip further processing if no Original Sender's Reference
      ** (non-API messages have no Original Sender's Reference)
     C     w@1           ifgt      0
      *
     C*****w@1           subst     p@orisrf      w@trno
     C     w@1           subst(p)  p@orisrf      w@trno
     C     w@trno        chain     mgorefd0                           70
      *
      ** If original message still exists, write ACK / NAK details
     C     *in70         ifeq      *off
      *
      ** Find the ACK / NAK date and time in field {177:YYMMDDHHMM}
     C     '{177:'       scan      p@rtext       w@1
     C                   add       5             w@1
     C     6             subst     p@rtext:w@1   w@mode
     C                   movel     w@mode        MODE
     C                   add       6             w@1
     C     4             subst     p@rtext:w@1   w@motm
     C                   movel     w@motm        MOTM
      *                                                                                       146340
      ** Set up Century field                                                                 146340
     C                   movel     MODE          cent                                         146340
     C     cent          iflt      '72'                                                       146340
     C                   move      '20'          MODEC                                        146340
     C                   else                                                                 146340
     C                   move      '19'          MODEC                                        146340
     C                   endif                                                                146340
      *
      ** Set up last action date and time and MIR
     C                   movel(p)  w@day         LADT
     C     w@month       lookup    tabmonn       tabmona                  77
     C     LADT          cat       tabmona:0     LADT
     C     LADT          cat       w@year:0      LADT
     C                   z-add     w@latm        LATM
      *
     C     22            subst     p@rtext:7     w@an_mir         22
     C                   movel(p)  MODE          MIR
     C     MIR           cat       w@an_mir:0    MIR
      *
      ** Find the Accept-Reject code in field {451:n}, and set up data
      ** and reference fields accordingly
     C     '{451:'       scan      p@rtext       w@1
     C                   add       5             w@1
     C     1             subst     p@rtext:w@1   w@acknak          1
     C     w@acknak      ifeq      '0'
     C                   move      'A'           ACNK
     C                   move      '3'           MGSG
     C                   move      'LACK'        MGST
     C                   clear                   MSE1
     C                   clear                   ELIN
     C                   else
     C                   move      'N'           ACNK
     C                   move      '4'           MGSG
     C                   move      'NACK'        MGST
      *
      ** If this is a NAK, extract the error code details
     C     '{405:'       scan      p@rtext       w@1
     C                   add       5             w@1
     C     3             subst     p@rtext:w@1   MSE1
     C                   add       3             w@1
     C     3             subst     p@rtext:w@1   ELIN
     C                   endif
      *
      ** Output 1st record of ACK / NAK to MSMSI2PD and update
      ** reference
     C                   movel     p@rtext       MDTA
     C                   write     msmsi2d0
     C                   update    mgorefd0
      *
      ** Commit transaction : (N)ACK data + reference file update
     C                   commit
      *
     C                   endif
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_trash       : Process unexpected data received in *INCOMING     *
      * --------         mode                                              *
      *                                                                    *
      * Called by      : sr_in                                             *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_trash      begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_trash'    @STK(Q)
      *
      ** NULL (may wish to add code here to log erroneous data)
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_dcon        : Disconnect from CBT; if database error            *
      * -------          indicated after connection, perform database      *
      *                  error process after disconnect.                   *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : MC8000M - MC_close                                *
      *                            MC_stop                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_dcon       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_dcon'     @STK(Q)
      *
      ** Shutdown compression server for transmission jobs if not
      ** already requested
     C     p@io          ifeq      'O'
     C     w@srvr_trq    andeq     'N'
     C                   movel(p)  '*SHUTDOWN'   q@prompt
     C                   call      'QSNDDTAQ'    q@snddtaq
     C                   movel     'Y'           w@srvr_trq
     C                   endif
      *
      ** If last return code indicates session not open, reset open flag
     C     w@rcnar       ifeq      'NOT_OPEN'
     C                   movel     'N'           w@open
     C                   endif
      *
      ** Save last return code
     C                   movel(p)  w@rcnar       w@enar
      *
      ** Attempt disconnection: close session; stop link.
     C     w@open        ifeq      'Y'
     C                   callb     'MC_close'
     C                   parm                    p@rc
     C                   movel(p)  'MC_close'    t@apifn
     C                   exsr      sr_analyse
      *
     C     w@rcnar       ifeq      'PROGRESS'
      *
     C                   callb     'MC_rcv_opclo'
     C                   parm      20            p@wait
     C                   parm                    p@msgbuf
     C                   parm                    p@apdu
     C                   parm                    p@rc
     C                   movel(p)  'MC_rcv_opclo't@apifn
     C                   movel(p)  p@msgbuf      t@tdat
     C                   exsr      sr_analyse
     C                   endif
     C                   endif
      *
     C     w@init        ifeq      'Y'
     C                   callb     'MC_stop'
     C                   parm                    p@rc
     C                   movel(p)  'MC_stop'     t@apifn
     C                   exsr      sr_analyse
     C                   endif
      *
      ** Perform abnormal termination processing if required:
     C     w@abnormal    ifeq      'Y'
      *
      **  - print error report
     C     w@prtopn      ifne      'Y'
     C                   open      ms8010au
     C                   movel     'Y'           w@prtopn
     C                   endif
     C                   write     ms8010f1
     C                   write     ms8010f2
     C                   write     ms8010f3
     C                   close     ms8010au
      *
      **  - send error message and terminate abnormally
     C                   exsr      srerr
      *
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_init        : Initialise program and session                    *
      * -------                                                            *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : MC8000M - MC_init                                 *
      *                  sr_open                                           *
      *                                                                    *
      **********************************************************************
      *
     C     sr_init       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_init'     @STK(Q)
      *
      ** Set environment variables
     C**** w@env1        cat       w@null:0      w@env            21
     C     w@env1        cat(p)    w@null:0      w@env            25
     C                   call      'ADDENVVAR'
     C                   parm                    w@env
     C                   clear                   w@env
     C     w@env2        cat       w@null:0      w@env
     C                   call      'ADDENVVAR'
     C                   parm                    w@env
      *
      ** Define data areas
     C     *dtaara       define                  msstat
     C     *dtaara       define                  sdstat
      *
      ** Define parameter lists
     C     q@rcvdtaq     plist
     C                   parm      p@dtqm        q@dtaq           10
     C                   parm      '*LIBL'       q@libl           10
     C                   parm      12050         q@length          5 0
     C                   parm                    q@dqm
     C                   parm      -1            q@wait            5 0
      *
     C     q@snddtaq     plist
     C                   parm      p@dtqc        q@dtaq
     C                   parm      '*LIBL'       q@libl
     C                   parm      50            q@length          5 0
     C                   parm                    q@dqc
      *
      ** Access SDSTAT for system prefix
     C                   in        sdstat
      *
      ** Access bank details
     C                   call      'AOBANKR0'
     C                   parm      *blanks       p@rtcd            7
     C                   parm      '*FIRST'      p@optn            7
     C     sdbank        parm      *blanks       dsfdy
      *
      ** If the Access Object returns an error code, database error
     C     p@rtcd        ifne      *blank
     C                   movel     'AOBANKR0'    w0file
     C                   movel     'bank details'w0key
     C                   z-add     02            w0ernb
     C                   movel     'MEM5003'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   exsr      srerr
     C                   endif
      *
      ** Proceessing for *INCOMING mode
     C     p@io          ifeq      'I'
      *
      ** Build arrays of SWIFT BIC+branch details v Midas branch code for
      ** use when assigning Midas branch to incoming messages (in sr_ix).
     C                   z-add     1             w@b               5 0
     C     *loval        setll     sdbrchl0
     C                   read      sdbrchl0                               50
     C     *in50         doweq     *off
     C     w@b           andle     99
     C                   movel     A8BRCD        br@midas(w@b)
     C                   movel(p)  w@brad        br@swift(w@b)
     C                   move      w@brbr        br@swift(w@b)
     C                   read      sdbrchl0                               50
     C                   add       1             w@b
     C                   enddo
      *
      ** Get module details (to check for AutoRecs II)
     C                   call      'AOMMODR0'
     C                   parm      *blanks       p@rtcd            7
     C                   parm      '*FIRST'      p@optn            7
     C     sdmmod        parm      *blanks       dsfdy
      *
      ** If the Access Object returns an error code, database error
     C     p@rtcd        ifne      *blank
     C                   movel     'AOMMODR0'    w0file
     C                   movel(p)  'modules'     w0key
     C                   z-add     03            w0ernb
     C                   movel     'MEM5003'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   exsr      srerr
     C                   endif
     C
     C                   endif
      *                                                                                       CSW209
      ** Check if SWIFT2009 is installed                                                      CSW209
      *                                                                                       CSW209
     C                   call      'SWIF2009'                                                 CSW209
     C                   parm                    p@rtcd                                       CSW209
      *                                                                                       CSW209
     C     p@rtcd        ifeq      'CSW2009'                                                  CSW209
     C                   eval      csw209 = 'Y'                                               CSW209
     C                   else                                                                 CSW209
     C                   eval      csw209 = 'N'                                               CSW209
     C                   endif                                                                CSW209
      *
      ** Get session details from file
     C     p@lmapid      chain(n)  MSMAPIL0                           51
     c     *in51         ifeq      *on
     C                   movel     'MSMAPIL0'    w0file
     C                   movel     p@lmapid      w0key
     C                   z-add     04            w0ernb
     C                   movel     'MEM5003'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   exsr      srerr
     C                   endif
      *
      ** Initialise failure flag, termination indicator, 'initialised',
      ** 'open' and 'server termination requested' flags and trace file name
     C                   movel     'N'           w@abnormal        1
     C                   movel     'N'           w@init            1
     C                   movel     'N'           w@open            1
     C                   movel     'N'           w@srvr_trq        1
     C                   movel     *off          *in01
     C     LIBR          cat       '_TRACE':0    p@trcf
      *
      ** Set up session details for API calls:
      **  - L-mapid name (null terminated)
     C     p@lmapid      cat       w@null:0      p@api_mapi
      *
      **  - Open type (and wait time in seconds if open type is 'Wait')
     C     MCOTYP        ifeq      'F'
     C                   z-add     1             p@force
     C                   else
     C                   z-add     0             p@force
     C     MCWAIT        mult      60            w@wait            9 0
     C                   endif
      *
      **  - recovery details (if recovery required)
     C     MCRECO        ifeq      'Y'
     C                   z-add     1             p@recover
     C                   z-add     MCSESS        p@sess
     C                   z-add     MCSEQN        p@seqn
     C*****MCSESS        add       1             p@sess                                128989 174459
     C     MCSEQN        add       1             p@seqn                                       128989
     C                   else
     C                   z-add     0             p@recover
     C                   z-add     0             p@sess
     C                   z-add     0             p@seqn
     C                   endif
      *
      ** Initialise session with CBT
     C                   callb     'MC_init'
     C                   parm                    p@trcf
     C                   parm                    p@rc
      *
      ** If initialise successful set 'initialised' indication and
      ** attempt to open session
     C                   movel(p)  'MC_init'     t@apifn
     C                   exsr      sr_analyse
     C     w@rcnar       ifeq      'SUCCESS'
     C                   movel     'Y'           w@init
     C                   exsr      sr_open
     C                   endif
                                                                                              CTI004
     C                   CALL      'AOSARDR0'                                                 CTI004
     C                   PARM      *BLANKS       PRTCD                                        CTI004
     C                   PARM      '*VERIFY'     POPTN                                        CTI004
     C                   PARM      'CTI004'      PSARD                                        CTI004
     C     SCSARD        PARM      SCSARD        DSFDY                                        CTI004
                                                                                              CTI004
     C                   IF        PRTCD = *Blanks                                            CTI004
     C                   EVAL      CTI004 = 'Y'                                               CTI004
     C                   ELSE                                                                 CTI004
     C                   EVAL      CTI004 = 'N'                                               CTI004
     C                   ENDIF                                                                CTI004
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_open        : Open session with CBT                             *
      * -------                                                            *
      *                                                                    *
      * Called by      : sr_init, sr_abort                                 *
      *                                                                    *
      * Calls          : MC8000M - MC_open                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_open       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_open'     @STK(Q)
      *
      ** Attempt to open session
     C                   callb     'MC_open'
     C                   parm                    p@api_mapi
     C                   parm                    p@recover
     C                   parm                    p@sess
     C                   parm                    p@seqn
     C                   parm                    p@force
     C                   parm      w@wait        p@wait
     C                   parm                    p@rc
      *
      ** If return code indicates open in progress, get open indication
     C                   movel(p)  'MC_open'     t@apifn
     C                   exsr      sr_analyse
     C     w@rcnar       ifeq      'PROGRESS'
      *
     C                   callb     'MC_rcv_opclo'
     C                   parm      w@wait        p@wait
     C                   parm                    p@msgbuf
     C                   parm                    p@apdu
     C                   parm                    p@rc
      *
      **  If open indication received set 'open' flag
     C                   movel(p)  p@msgbuf      t@tdat
     C                   movel(p)  'MC_rcv_opclo't@apifn
     C                   exsr      sr_analyse
     C     w@rcnar       ifeq      'SUCCESS'
     C                   movel     'Y'           w@open
     C                   endif
      *
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_abort       : Attempt to recover aborted session if due to      *
      * --------         incorrect message format                          *
      *                                                                    *
      * Called by      : sr_out                                            *
      *                                                                    *
      * Calls          : sr_open                                           *
      *                                                                    *
      **********************************************************************
      *
     C     sr_abort      begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_abort'    @STK(Q)
      *
      ** Set status flag to indicated session no longer open
     C                   movel     'N'           w@open            1
      *
      ** If abort type due to invalid message (ie. abort type >=50)
      ** attempt to reopen session
     C     p@ab_type     ifge      50
     C                   z-add     p@ab_type     w@abn
     C                   z-add     1             p@recover
     C                   z-add     p@sessx       p@sess
     C                   z-add     p@seqnx       p@seqn
     C                   call      'QCMDEXC'
     C                   parm                    w@dly
     C                   parm      14            w@lgth           15 5
     C                   exsr      sr_open
     C                   endif
      *
      ** If session reopened successfully return to calling routine
      ** indicating message was in error (p@acknak=0 => NAK) but recovery
      ** not required and set up abort details in message error code.
     C     w@open        ifeq      'Y'
     C                   movel(p)  'SUCCESS'     w@rcnar
     C                   z-add     2             p@dtatyp
     C                   z-add     0             p@acknak
     C                   movel     'CAS'         MSE1
     C                   movel     w@aba         ELIN
      *
      ** else return with return-code set to not_open to force end of
      ** session with recovery flags set
     C                   else
     C                   movel(p)  'NOT_OPEN'    w@rcnar
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
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
      *****************************************************************
      *
     C     *PSSR         begsr
      *
     C     @run          ifeq      *blank
     C                   move      'Y'           @run              1
      *
      ** Shutdown compression server for transmission jobs if not
      ** already requested
     C     p@io          ifeq      'O'
     C     w@srvr_trq    andeq     'N'
     C                   movel(p)  '*SHUTDOWN'   q@prompt
     C                   call      'QSNDDTAQ'    q@snddtaq
     C                   movel     'Y'           w@srvr_trq
     C                   endif
      *
     C                   dump
      *
     C                   endif
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     '*PSSR'       @STK(Q)
      *
     C                   seton                                        U7U8LR
     C                   return
     C                   endsr
      *
      ********************************************************************
     C*                                                                         184427
     C** tabtyp add MT340, MT341, MT360, MT361 and MT362.                       184427
     C** tabtyp add MT103                                                       CRE008
      /COPY MSCPYSRC,SRERRC
      /COPY MSCPYSRC,CUSAPIDTA
**CTDATA cpy@
(c) Misys International Banking Systems Ltd. 2001
**CTDATA tabtyp
100A
103A
200A
201B
202A
203B
300A
320A
324A
330A
335A
350D
900A
910A
940C
950C
340A
341A
360A
361A
362A
370E                                                                                          CSW212
600A                                                                                          CSW212
**CTDATA tabmonn
01JAN
02FEB
03MAR
04APR
05MAY
06JUN
07JUL
08AUG
09SEP
10OCT
11NOV
12DEC
**CTDATA ar1
??4C<
??4F!
??50&
??5C*
??5E;
??6C%
??6D_
??6E>
??7B#
??7C@
??7E=
??7F"
??C0{
??D0}
**CTDATA tabty2                                                                               CSW212
370:19A::NETT                                                                                 CSW212
**CTDATA tabty3                                                                               CSW212
370:98A::VALU                                                                                 CSW212
