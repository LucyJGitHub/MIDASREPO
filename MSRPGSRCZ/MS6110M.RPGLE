     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  ALWNULL(*USRCTL)                                             *                       CSW034
/*EXI *  TEXT('Midas MS Midas/SWIFT Meridian communication')          *
      *****************************************************************
      *                                                               *
      *  Midas - Midas SWIFT                                          *
      *                                                               *
      *  MS6110M - Midas/SWIFT Meridian communications                *
      *                                                               *
      ***Function:**This*program*effects*communications*between*the****         CSW025
      **************Midas/SWIFT*module*and*a*Meridian*MQ*Series*Queue**         CSW025
      *****************************************************************         CSW025
      **************It*is*used*for*both*incoming*and*outgoing**********         CSW025
      **************messages.*If*used*to*send*outgoing*messages********         CSW025
      **************a*server*job*(MS_M2M_SRV)*should*be*submitted******         CSW025
      **************for*each*instance*to*format*them.******************         CSW025
      *  Function:  This program effects communication between Midas  *         CSW025
      *             and Meridian using Data Queues or MQSeries Queues *         CSW025
      *                                                               *         CSW025
      *             It is used for both incoming and outgoing         *         CSW025
      *             messages. If used to send outgoing messages       *         CSW025
      *             a server job (MS_M2M_SRV) should be submitted     *         CSW025
      *             for each instance to format them.                 *         CSW025
      *                                                               *
      *  Called By: MSC6110 - Midas/SWIFT Meridian communications     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD051624           Date 23Sep20               *
      *  Prev Amend No. AR989496           Date 13Jun12               *
      *                 CSD102             Date 08Jan19               *
      *                 MD048231           Date 17Jan18               *
      *                 MD046248           Date 27Oct17               *
      *                 AR214111           Date 26Jun15               *
      *                 250527             Date 19Aug14               *
      *                 251373             Date 30Jan08               *
      *                 MD023406           Date 12Nov13               *
      *                 AR976772           Date 23May12               *
      *                 CSW212             Date 03May12               *
      *                 252317             Date 15Feb08               *
      *                 CER059             Date 19Jul10               *
      *                 BUG21921           Date 26Jan09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      *                 257554             Date 05Nov08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 246522             Date 23Mar07               *
      *                 BUG14494           Date 08Aug07               *
      *                 245310             Date 30Jan07               *
      *                 244430             Date 04Jan07               *
      *                 BUG13405           Date 23Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242607             Date 22Aug06               *
      *                 BUG12318           Date 04Nov06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW039             Date 15Sep05               *
      *                 CSW038             Date 13Apr05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4717            Date 03Dec04               *
      *                 BUG3189            Date 10Jun04               *
      *                 CTI004             Date 12Apr04               *
      *                 CSW034             Date 09Jan04               *
      *                 220126             Date 29Jul03               *
      *                 CRE008             Date 23May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW025             Date 15Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 184427             DATE 11Oct00               *
      *                 184013             DATE 11Oct00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW017 *CREATE     Date 11Feb99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD051624 - MT940's msgs found in the Outstanding Message     *
      *             Details Enquiry Screen are dated incorrectly.     *
      *           - Introduced system value 'MachineDateforTRAN' to   *
      *             retrieved the machine time.                       *
      *  AR989496 - Remove redundant code related to dtaara/MEDTA     *
      *           - Causes DBase Error in MS_MED2MID job              *
      *           - (Child:AR989497)                                  *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD048231 - Removed/Changed fix 251373 in order to process    *
      *             PAPER network messages using MQ queue             *
      *  MD046248 - Finastra Rebranding                               *
      *  AR214111 - Incoming messages were not retrieved properly by  *
      *             MidasPlus. Reveresed part of 257554 to remove the *
      *             checking of the zone as the incoming message does *
      *             not have this information.                        *
      *           - Applied for MD034610.                             *
      *  250527 - When messages are passed from MMM via MQ Series set *
      *           header length to '1'. Applied fix 250335.           *
      *  251373 - Do not process 'PAPER' messages coming from         *
      *           MidasPlus.                                          *
      *  MD023406 - Convert carriage return + line x'0D15' to x0D25'. *
      *           - Ignore header on incoming message.                *
      *  AR976772 - Value date century is not populated for all types *
      *  CSW212 - SWIFT 2012 Changes                                  *
      *  252317 - Increase branches array size from 99 to 999.        *
      *           If BIC code ends in 'XXX' and BIC is not found in   *
      *           SDBRCHPD then use default branch                    *
      *           (i.e. branch of bank's internal customer)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG21921 - Apply fix 20658 ; fix was applied through         *
      *             bug 257554                                        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  257554 - Reversed BUG14494.                                  *
      *  246522 - Applied 1.2 core fix 243388.                        *
      *  243388 - Don't start with the buffer assuming a header of    *
      *           HLEN length.                                        *
      *  BUG14494 - Inward Funds Transfer missing                     *
      *  245310 - Remove assumption that a default queue manager      *
      *           exists and should be used                           *
      *  244430 - Call RTVNODEREF when CSW038 is off.                 *
      *  BUG13405 - Applied fix 243388                                *
      *  242607 - Change to work with clustered queues / remote QMGR. *
      *  BUG12318 - Remove call to RTVNODEREF when CSW038 is ON.      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW039 - Add System/Priority to Correlation ID               *
      *  CSW038 - Change to allow communication with MMM using        *
      *           MQSeries instead of data queues.  This change       *
      *           takes advantage of the fact that MQSeries support   *
      *           was already present, but reworks it so that         *
      *           the correct message header type is used (the        *
      *           existing support was for the MINT Interface).  It   *
      *           also attempts to allow for the alternative CR/LF    *
      *           format that is sometimes found in iSeries           *
      *           SWIFT messages.  Further, the option to use         *
      *           a queue manager other than the default one was      *
      *           added, and EOD messages, if requested, are now      *
      *           sent to the relevant MQSeries queue, if we are      *
      *           running in that mode.                               *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4717- Messages from MMM are dropped too early.            *
      *  BUG3189- Apply keyed data queue changes for CSW034.          *
      *  CTI004 - MidasPlus-TI Integration Enhancements               *
      *           Routing Swift Messages                              *
      *  CSW034 - Midas Message Manager Global Processing             *
      *  220126 - Send header rundate next rundate & system id        *
      *  CRE008 - Cash Management                                     *
      *           Here, add type 103 in TABTYP to extract             *
      *           date and amount in MSIXI2PD                         *
      *  CSW025 - Midas Message Manager                               *
      *           - Send messages to Meridian Link via Data Queue     *
      *   CDL008 - Continuous Linked Settlement (Recompiled MGOREFPD) *
      *  184427 - Add MT340s and MT360s                               *
      *  184013 - Swift 2000 get correct date format from 30V         *
      *  CSW017 - Midas/Swift Meridian interface                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Notes:                                                       *
      *  ------                                                       *
      *                                                               *
      *    o  This module uses the QMQM API to exchange messages,     *
      *       ACKs and NAKs with Meridian MQ series queues.           *
      *                                                               *
      *****************************************************************
      /EJECT
     FMSMCIDL0  UF   E           K disk    infsr(srfile)
     FMGOREFL0  UF   E           K disk    infsr(srfile)
     F                                     commit
     FMGOMSGPD  IF   E           K disk    infsr(srfile)
     FMSMSI2L9  IF   E           K disk    infsr(srfile)
     F                                     rename(msmsi2d0:msmsi2d9)
     F/COPY WNCPYSRC,MS6110MF01
     FSDBRCHL0  IF   E           K disk    infsr(srfile)
     F/COPY WNCPYSRC,MS6110MF02
     FSDCUSTL7  IF   E           K disk    infsr(srfile)
     FMSMSI2PD  O    E           K disk    infsr(srfile)
     F                                     commit
     FMSIXI2PD  O    E           K disk    infsr(srfile)
     F                                     commit
     FMS6110AU  O    E             printer infsr(srfile)
     F                                     oflind(*in66)
     F                                     usropn
     F***HOSTSYSTL2IF***E           K disk                                            CSW034 BUG3189
      /EJECT
      /COPY MSCPYSRC,SRERRD
      *                                                                                       245310
      ** +--------------------------------------+                                             245310
      ** ¦ Manually included D-specs            ¦                                             245310
      ** ¦ =========================            ¦                                             245310
      ** +--------------------------------------+                                             245310
      *                                                                                       245310
      ** +--------------------------------------+                                             245310
      ** ¦ Named constants                      ¦                                             245310
      ** ¦ ===============                      ¦                                             245310
      ** +--------------------------------------+                                             245310
      *                                                                                       245310
      * Constant to hold input parameter for AOSVALR0.                                        245310
     D MQManager       C                   Const('MQQueueManagerMMM')                         245310
     D MachineDate     C                   Const('MachineDateforTRAN')                      MD051624
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
     D*br@midas*       S              3    dim(99)                                            252317
     D*br@swift*       S             11    dim(99)                                            252317
     D br@midas        S              3    dim(999)                                           252317
     D br@swift        S             11    dim(999)                                           252317
      ** Midas branch code v SWIFT branch code
      *
     D w@msgbuf        S              1    DIM(12000)                                       MD023406
      ** message buffer for conversion of carriage return + line feed                       MD023406
      *                                                                                     MD023406
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
     D/COPY WNCPYSRC,MS6110MD01
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
                                                                                CSW025
     D  mestat       E DS                  extname(MESTAT) dtaara(MESTAT)       CSW025
      ** Midas Message Management status data area                              CSW025
                                                                                CSW025
     D  sdstat       E DS                  extname(SDSTAT)
     Dren@mode       E                     extfld(MODE)
      ** SDSTAT for system prefix
     D/COPY WNCPYSRC,MS6110MD02
      *
     D                 DS
     D  q@dqm                  1  12050
     D  q@sndref               1     50
     D  q@msgbuf              51  12050
      ** Data queue entry (message)
      *
     D                 DS
     D  q@dqc                  1     50
     D  q@prompt               1     50
      ** Data queue entry (control)
      *
      /SPACE 2
      *
     D                 DS
     Dp@msgbuf         S          12000
      ** API string parameters
     D/COPY WNCPYSRC,MS6110MD03
      *
     D APHEAD        E DS                  EXTNAME(APHEADPD)
      ** Incoming message header format
      *
     D APMH17        E DS                  EXTNAME(APMH17PD)                    CSW025
     D/COPY WNCPYSRC,MS6110MD04
      ** Meridian 1.7 header format                                             CSW025
                                                                                CSW025
     D                 DS
     D  w@tx3                  1      4    inz('}{4:')
     D  w@cr                   5      5    inz(x'0d')
     D  w@lf                   6      6    inz(x'25')
     D  w@crlf                 5      6
     D  w@stag                 7      9                                                       125554
     D  w@scan                 5      9                                                       125554
     D  w@cr2                 10     10    inz(x'0d')                           CSW038
     D  w@altlf               11     11    inz(x'15')                           CSW038
     D  w@altcrlf             10     11                                         CSW038
     D  txt3                   1      6
     Dw@null           S              1    inz(x'00')
     Dw@dly            S             14    inz('DLYJOB DLY(10)')
      ** Control codes and fixed texts
      *
                                                                                              CSW209
     Dcsw209           S              1    inz('N')                                           CSW209
      ** CSW209 switch                                                                        CSW209
                                                                                              CSW209
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

      **  Declare MQI structures needed
      * MQI Constants
     D/COPY QMQM/QRPGLESRC,CMQR

      ** Object Descriptor
     D MQOD            DS
     D/COPY QMQM/QRPGLESRC,CMQODR

      ** Message Descriptor
     D MQMD            DS
     D/COPY QMQM/QRPGLESRC,CMQMDR

      ** Get message options
     D MQGMO           DS
     D/COPY QMQM/QRPGLESRC,CMQGMOR

      ** Put message options
     D MQPMO           DS
     D/COPY QMQM/QRPGLESRC,CMQPMOR


      ** The include below brings in the return code structure that
      ** is used in calls to OS/400 APIs.
     D/COPY QSYSINC/QRPGLESRC,QUSEC
      * API Error code parameter

      ** --- Start of fields used by access programs -------------------------- CSW025
     D @RtCd           S              7A                                        CSW025
      ** Return code                                                            CSW025
     D @Optn           S              7A                                        CSW025
      ** Option                                                                 CSW025
     D @SARD           S              6A                                        CSW025
      ** Switchable feature ID (for AOSARDR0)                                   CSW025
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CSW025
      ** External DS for SAR details                                            CSW025
      ** --- End of fields used by access programs ---------------------------- CSW025
                                                                                CSW025
     D                 DS                                                       CSW025
     D BJRDNB5S                       5S 0                                      CSW025
     D BJRDNB5A                       5A   OVERLAY(BJRDNB5S)                    CSW025
     D BJDNWD5S                       5S 0                                      CSW025
     D BJDNWD5A                       5A   OVERLAY(BJDNWD5S)                    CSW025
                                                                                CSW025
     D DSTimeStamp     DS                                                                   MD051624
     D  DSYYYY                 1      4                                                     MD051624
     D  DSMM                   6      7                                                     MD051624
     D  DSDD                   9     10                                                     MD051624
     D  DSHH                  12     13                                                     MD051624
     D  DSMN                  15     16                                                     MD051624
     D  DSSC                  18     19                                                     MD051624
     D  DSMS                  21     26                                                     MD051624
      ** Declared variables for enhancement CTI004                                            CTI004
                                                                                              CTI004
     D PMSGBUF         S           9999                                                       CTI004
     D PMTPY           S              3                                                       CTI004
     D POKFLG          S              1                                                       CTI004
     D CTI004          S              1                                                       CTI004
     D PRTCD           S              7                                                       CTI004
     D POPTN           S              7                                                       CTI004
     D PSARD           S              6                                                       CTI004
     D PSysVal01       S             20A                                                      245310
     D PCurSet01       S            200A                                                      245310
     D PSysVal02       S             20A                                                      245310
     D PCurSet02       S            200A                                                      245310
     D PSysVal03       S             20A                                                      245310
     D PCurSet03       S            200A                                                      245310
     D PSysVal04       S             20A                                                      245310
     D PCurSet04       S            200A                                                      245310
     D PSysVal05       S             20A                                                      245310
     D PCurSet05       S            200A                                                      245310
     D PSysVal06       S             20A                                                      245310
     D PCurSet06       S            200A                                                      245310
     D PSysVal07       S             20A                                                      245310
     D PCurSet07       S            200A                                                      245310
     D PSysVal08       S             20A                                                      245310
     D PCurSet08       S            200A                                                      245310
     D PSysVal09       S             20A                                                      245310
     D PCurSet09       S            200A                                                      245310
     D PSysVal10       S             20A                                                      245310
     D PCurSet10       S            200A                                                      245310
                                                                                              CTI004
      ** Declared variable for system value setting                                         MD048231
     D MMMPaper        S              1A                                                    MD048231
      *                                                                                     MD051624
     D WMACFLAG        S              1                                                     MD051624
     D WLATM           S              6                                                     MD051624
     D PTimeStamp      S               Z                                                    MD051624
     D PDateIn         S              8                                                     MD051624
     D PMDNO           S              5P 0                                                  MD051624
     D PDATE6          S              6  0                                                  MD051624
     D PDATE7          S              7                                                     MD051624
      /EJECT
      *****************************************************************
      *  Index to Subroutines                                         *
      *                                                               *
      *  sr_init       : Initialise program                           *
      *  sr_trace      : Trace                                        *
      *  sr_in         : Get incoming messages and write to database  *
      *  sr_esctr      : Process Escape Sequence Translations         *                       CSW209
      *  sr_out        : Format and transmit outgoing messages        *
      *  sr_DQin       : Get incoming Data Queue msgs and write to d/b*         CSW025
      *  sr_DQout      : Format and transmit outgoing Data Queue msgs *         CSW025
      *  sr_DQeod      : Send EOD message to Data Queue               *         CSW025
      *  sr_msg        : Write incoming message to database           *
      *  sr_ix         : Generate index (reference) record            *
      *  sr_typa       : Process incoming messages of type A          *
      *  sr_typb       : Process incoming messages of type B          *
      *  sr_typc       : Process incoming messages of type C          *
      *  sr_typd       : Process incoming messages of type D          *
      *  sr_rpt        : Process report (ACK / NAK)                   *
      *  sr_trash      : Process unexpected data                      *
      *  sr_term       : Program termination                          *
      *  sr_open       : Open MQ series queue                         *
      *  sr_close      : Close MQ series queue                        *
      *  *PSSR         : Standard program exception error routine     *
      *****************************************************************
      /EJECT
      *
      ** Set up copyright parameter
     C                   movea     cpy@          cpy2@            80
      *
     C     *entry        plist
     C                   parm                    p@mcid           26
     C                   parm                    p@dtqm           10
     C                   parm                    p@dtqc           10
     C                   parm                    p@io              1
     C                   parm                    p@eod             4            CSW025
      *
      ** Push routine
     C                   z-add     1             Q
     C                   movel     'mainline'    @STK(Q)
      *
      ** Perform initial process
     C                   exsr      sr_init
      *
      *******************                                                       CSW025
      ***If*MQ*series*queue opened successfully...                              CSW025
     C*****w@open********ifeq      'Y'                                          CSW025
                                                                                CSW025
     C                   if         CSW025 = 'Y'                                CSW025
     C                                AND CSW038 = 'N'                          CSW038
      * If export is via Data Queues                                            CSW025
                                                                                CSW025
      ** execute process for incoming or outgoing messages                      CSW025
     C     p@io          ifeq      'I'                                          CSW025
     C                   exsr      sr_DQin                                      CSW025
     C                   else                                                   CSW025
     C                   exsr      sr_DQout                                     CSW025
     C                   endif                                                  CSW025
                                                                                CSW025
     C                   else                                                   CSW025
      * export is via MQSeries                                                  CSW025
                                                                                CSW025
      ** If no error on opening MQSeries queue                                  CSW025
     C                   if         w@MQOpenErr = 'N'                           CSW025
     C                              AND w@MQConnErr = 'N'                                     245310
      *
      ** execute process for incoming or outgoing messages
     C     p@io          ifeq      'I'
     C                   exsr      sr_in
     C                   else
     C                   exsr      sr_out
     C                   endif
                                                                                CSW025
     C                   endif                                                  CSW025
      *
     C                   endif
      *
      ** Program termination
      *
     C                   exsr      sr_term
      *
     C                   seton                                        LR
      /EJECT
      **********************************************************************
      * sr_trace       : Trace (if requested by user).                     *
      * --------                                                           *
      *                                                                    *
      * Called by      : sr_init, sr_in, sr_out, sr_term                   *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_trace      begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_trace  '  @STK(Q)
      *
      ** Check whether trace requested. If it is, write trace information
      ** to report.
     C                   in        msstat
     C     TRACF         ifeq      'T'
      *
      ** If spool file not already open, open it now.
     C     w@prtopn      ifne      'Y'
     C                   movel     'Y'           w@prtopn          1
     C                   open      ms6110au
     C                   write     ms6110f1
     C                   endif
      *
      ** Check for overflow and rewrite headings if necessary.
     C     *in66         ifeq      *on
     C                   movel     *off          *in66
     C                   write     ms6110f1
     C                   endif
      *
      ** Set up standard details and write to report
     C                   time                    PR@TI
     C     REASON        ifne      0
     C                   movel(p)  REASON        PR@RC
     C                   else
     C                   clear                   PR@RC
     C                   endif
     C                   write     ms6110t1
      *
      ** If data in buffer, write this too
     C     t@tdat        ifne      *blank
     C                   movel(p)  t@tdat        PR@DT
     C                   write     ms6110t2
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
      * Calls          : QMQM                                              *
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
     C                   movel     mgde          smgde             6 0                        CSW034
     C                   movel     q@sndref      w@trn            16
     C     w@trn         chain     mgorefl0                           50

      ** Set dataq priority key                                                              BUG3189
     C     mtpy          ifeq      '940'                                                     BUG3189
     C     mtpy          oreq      '950'                                                     BUG3189
     C                   move      '90'          q@skey                                      BUG3189
     C                   else                                                                BUG3189
     C                   move      '10'          q@skey                                      BUG3189
     C                   end                                                                 BUG3189
     C                   movel(p)  q@skey        MDCID
      *
      ** Set up message details
      ** (API header format plus message sent from compression program)
     C/COPY WNCPYSRC,MS6110MC01
     C     NWRK          ifeq      'PAPER'                                                    251373
     C     MMMPaper      ANDNE     'Y'                                                      MD048231
     C                   GOTO      DISCRD                                                     251373
     C                   endif                                                                251373
     C     NWRK          ifeq      'MINT'
     C                   movel(p)  'MIDAS_MINT'  APTGTTYPE
     C                   else
     C                   movel(p)  'MIDAS_SWIFT' APTGTTYPE
     C                   endif
     C                   EVAL      p@msgbuf = APHEAD + q@msgbuf
     C/COPY WNCPYSRC,MS6110MC02

      ** If we are sending messages to MMM via MQSeries then we have to                       CSW038
      ** set the Meridian 1.7 header fields                                                   CSW038
     C                   if        CSW038 = 'Y'                                               CSW038
     C                   eval      RAMSGTYPE = 'Midas_SWIFT'                                  CSW038
     C                   eval      RATGTSYS  = 'Midas'                                        CSW038
     C                   EVAL      p@msgbuf = APMH17 + q@msgbuf                               CSW038
     C                   else                                                                 CSW038
     C                   EVAL      p@msgbuf = APHEAD + q@msgbuf                               CSW038
     C                   endif                                                                CSW038

      ** Get message length

     C     w@null        scan      p@msgbuf      p@msglen                 99    *
     C     *in99         ifeq      *off
     C                   z-add     12000         p@msglen
     c                   endif

      ** Remove null byte

     C     w@null:' '    xlate     p@msgbuf      p@msgbuf

      ** MDFMT (Format Name) is a subfield of the MQMD data structure,
      ** defined in the include member CMQMDR.
      ** FMSTR is a named constant defined in CMQR; it contains 'MQSTR   '.
     C                   EVAL      MDFMT = FMSTR
     C/COPY WNCPYSRC,MS6110MC03

      ** Send message
     C                   Z-ADD     MQPUT         CID
     C                   CALL      'QMQM'
     C                   PARM                    CID               9 0
     C                   PARM                    HCONN             9 0
     C                   PARM                    HIN               9 0
     C                   PARM                    MQMD
     C                   PARM                    MQPMO
     C                   PARM                    p@msglen          9 0
     C                   PARM                    p@msgbuf
     C                   PARM                    CCODE             9 0
     C                   PARM                    REASON            9 0
      *
      ** Trace
     C                   movel     '*PUT   '     PR@FN
     C                   movel     q@msgbuf      t@tdat
     C                   exsr      sr_trace

      ** If send message failed, indicate abnormal end

     C                   IF        REASON <> RCNONE

      ** Log recovery details

     C     p@mcid        chain     MSMCIDL0                           51
     C     *in51         ifeq      *off
     C                   movel(p)  TRNO          MCRSTR
     C                   movel     'Y'           MCRECO
     C                   update    MSMCIDD0
     C                   endif
      *
     C                   movel     'Y'           w@abnormal
     C                   movel     'QMQM     '   w0file
     C                   movel     'MEM6001'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   movel     'Send message'w0key
     C                   movel     REASON        w0reas
     C                   z-add     101           w0ernb

      ** If no failure

     C                   else
      *
      ** If this was recovery run, recovery was a success so reset
      ** details
     C     MCRECO        ifeq      'Y'
     C     p@mcid        chain     MSMCIDl0                           50
     C     *in50         ifeq      *off
     C                   clear                   MCRSTR
     C                   movel     'N'           MCRECO
     C                   update    MSMCIDD0
     C                   endif
     C                   endif
      *
     C                   endif
      *
      ** Update message status: RECO -> failed on this attempt
      ** (set for recovery); TRAN -> Transmitted OK.
      *                                                                                       251373
     C     DISCRD        TAG                                                                  251373
      *                                                                                       251373
     C     w@abnormal    ifeq      'Y'
     C                   movel     'RECO'        MGST
     C                   movel     'Y'           MPDE                                         134491
     C                   else
     C                   movel     '3'           MGSG
     C                   movel     'TRAN'        MGST
     C                   endif
      *                                                                                     MD051624
      ** If 'MachineDateforTRAN' system value is ON, get machine time                       MD051624
      *                                                                                     MD051624
     C                   IF        WMACFLAG = 'Y'                                           MD051624
     C                   CALLB     'ZAGENTMSTM'                                             MD051624
     C                   PARM                    PTimeStamp                                 MD051624
     C                   MOVE      PTimeStamp    DSTimeStamp                                MD051624
      *                                                                                     MD051624
      ** Convert from YYYYY to 99999                                                        MD051624
      *                                                                                     MD051624
     C                   EVAL      PDATEIN = DSYYYY + DSMM + DSDD                           MD051624
     C                   CALLB     'ZDATE10'                                                MD051624
     C                   PARM                    PDateIN                                    MD051624
     C                   PARM                    PMDNO                                      MD051624
      *                                                                                     MD051624
      ** Convert from 99999 to DDMMMYY                                                      MD051624
      *                                                                                     MD051624
     C                   CALL      'ZDATE2'                                                 MD051624
     C                   PARM                    PMDNO                                      MD051624
     C                   PARM                    BJDFIN                                     MD051624
     C                   PARM      *ZERO         PDATE6                                     MD051624
     C                   PARM      *BLANKS       PDATE7                                     MD051624
     C                   MOVEL     PDATE7        LADT                                       MD051624
      *                                                                                     MD051624
      ** Move DS time to numeric                                                            MD051624
      *                                                                                     MD051624
     C                   EVAL      WLATM = DSHH + DSMN + DSSC                               MD051624
     C                   MOVE      WLATM         LATM                                       MD051624
     C                   ELSE                                                               MD051624
     C                   movel     BJMRDT        LADT
     C                   TIME                    LATM
     C                   ENDIF                                                              MD051624
     C                   update    mgorefd0
     C                   commit
      *
      ** else (if no messages to send) wait for prompt/time-out
     C                   else
                                                                                CSW038
      * If Midas EoD processing is requested, the first time we get             CSW038
      * here all messages must have been sent so send the RunDate               CSW038
      * Synchronisation message just once.                                      CSW038
     C                   if        p@eod = '*EOD'                               CSW038
     C                   exsr      sr_eod                                       CSW038
     C                   eval      p@eod = ' '                                  CSW038
     C                   endif                                                  CSW038
                                                                                CSW038
     C                   callb     'MSC8011M'
     C                   endif
     C                   enddo
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************                  CSW038
      * sr_eod         : Send EOD message to MQ   Queue                    *                  CSW038
      * ------                                                             *                  CSW038
      *                                                                    *                  CSW038
      * Called by      : Mainline                                          *                  CSW038
      *                                                                    *                  CSW038
      * Calls          :                                                   *                  CSW038
      *                                                                    *                  CSW038
      **********************************************************************                  CSW038
      *                                                                                       CSW038
     C     sr_eod        begsr                                                                CSW038
      *                                                                                       CSW038
      ** Push subroutine                                                                      CSW038
     C                   add       1             Q                                            CSW038
     C                   movel     'sr_eod'      @STK(Q)                                      CSW038
                                                                                              CSW038
      ** Message consists of                                                                  CSW038
      ** - Meridian 1.7 header                                                                CSW038
      ** - Specific EOD text                                                                  CSW038
      **         - Rundate and DateOfNextWorkingDay in 5A format                              CSW038
                                                                                              CSW038
      ** Set the Meridian 1.7 header fields                                                   CSW038
     C                   eval      RAMSGTYPE = 'Rundate_Synch'                                CSW038
     C                   eval      RATGTSYS  = 'Midas'                                        CSW038
                                                                                              CSW038
      ** Convert Rundate & DNWD from 3P to 5A                                                 CSW038
     C                   z-add     BJRDNB        BJRDNB5S                                     CSW038
     C                   z-add     BJDNWD        BJDNWD5S                                     CSW038
                                                                                              CSW038
     C                   EVAL      p@msgbuf = APMH17 + BJRDNB5A + BJDNWD5A +                  CSW038
     C                                        LIBR                                            CSW038
                                                                                              CSW038
      ** Send message                                                                         CSW038
      ** Get message length                                                                   CSW038
                                                                                              CSW038
     C     w@null        scan      p@msgbuf      p@msglen                 99    *             CSW038
     C     *in99         ifeq      *off                                                       CSW038
     C                   z-add     12000         p@msglen                                     CSW038
     c                   endif                                                                CSW038
                                                                                              CSW038
      ** Remove null byte                                                                     CSW038
                                                                                              CSW038
     C     w@null:' '    xlate     p@msgbuf      p@msgbuf                                     CSW038
                                                                                              CSW038
      ** MDFMT (Format Name) is a subfield of the MQMD data structure,                        CSW038
      ** defined in the include member CMQMDR.                                                CSW038
      ** FMSTR is a named constant defined in CMQR; it contains 'MQSTR   '.                   CSW038
     C                   EVAL      MDFMT = FMSTR                                              CSW038
                                                                                              CSW038
      ** Send message                                                                         CSW038
     C                   Z-ADD     MQPUT         CID                                          CSW038
     C                   CALL      'QMQM'                                                     CSW038
     C                   PARM                    CID               9 0                        CSW038
     C                   PARM                    HCONN             9 0                        CSW038
     C                   PARM                    HIN               9 0                        CSW038
     C                   PARM                    MQMD                                         CSW038
     C                   PARM                    MQPMO                                        CSW038
     C                   PARM                    p@msglen          9 0                        CSW038
     C                   PARM                    p@msgbuf                                     CSW038
     C                   PARM                    CCODE             9 0                        CSW038
     C                   PARM                    REASON            9 0                        CSW038
      *                                                                                       CSW038
      ** Trace                                                                                CSW038
     C                   movel     '*PUT   '     PR@FN                                        CSW038
     C                   movel     q@msgbuf      t@tdat                                       CSW038
     C                   exsr      sr_trace                                                   CSW038
                                                                                              CSW038
      ** If send message failed, indicate abnormal end                                        CSW038
                                                                                              CSW038
     C                   IF        REASON <> RCNONE                                           CSW038
                                                                                              CSW038
     C                   movel     'Y'           w@abnormal                                   CSW038
     C                   movel     'QMQM     '   w0file                                       CSW038
     C                   movel     'MEM6001'     w0msgd                                       CSW038
     C                   movel     'MIDAS  '     w0msgf                                       CSW038
     C                   movel     'Send EOD msg'w0key                                        CSW038
     C                   movel     REASON        w0reas                                       CSW038
     C                   z-add     204           w0ernb                                       CSW038
                                                                                              CSW038
                                                                                              CSW038
      ** Trace                                                                                CSW038
     C                   movel     '*PUT   '     PR@FN                                        CSW038
     C                   movel     p@msgbuf      t@tdat                                       CSW038
     C                   exsr      sr_trace                                                   CSW038
                                                                                              CSW038
     C                   else                                                                 CSW038
                                                                                              CSW038
      ** If send message succeeded, let Midas know processing can continue                    CSW038
     C     *lock         in        mestat                                                     CSW038
     C                   eval      MRDEOD = 'Y'                                               CSW038
     C                   out       mestat                                                     CSW038
                                                                                              CSW038
     C                   endif                                                                CSW038
                                                                                              CSW038
      ** Pop subroutine                                                                       CSW038
     C                   clear                   @STK(Q)                                      CSW038
     C                   sub       1             Q                                            CSW038
     C                   endsr                                                                CSW038
      /EJECT                                                                                  CSW038
      **********************************************************************    CSW025
      * sr_DQout       : Format and transmit outgoing msgs to a Data Queue *    CSW025
      * --------                                                           *    CSW025
      *                                                                    *    CSW025
      *                                                                    *    CSW025
      * Called by      : Mainline                                          *    CSW025
      *                                                                    *    CSW025
      * Calls          : QSNDDTAQ                                          *    CSW025
      *                : QRCVDTAQ                                          *    CSW025
      *                : MSC8011M                                          *    CSW025
      *                                                                    *    CSW025
      **********************************************************************    CSW025
      *                                                                         CSW025
     C     sr_DQout      begsr                                                  CSW025
      *                                                                         CSW025
      ** Push subroutine                                                        CSW025
     C                   add       1             Q                              CSW025
     C                   movel     'sr_DQout'    @STK(Q)                        CSW025
                                                                                CSW025
      ** Prompt server for first message                                        CSW025
     C                   movel(p)  '*NEXT'       q@prompt                       CSW025
     C                   call      'QSNDDTAQ'    q@snddtaq                      CSW025
                                                                                CSW025
      ** DoUntil termination requested or an abormal condition detected         CSW025
     C     *in01         doueq     *on                                          CSW025
     C     w@abnormal    oreq      'Y'                                          CSW025
                                                                                CSW025
      ** Check for termination request                                          CSW025
     C                   shtdn                                        01        CSW025
                                                                                CSW025
      ** If termination not requested prompt server to prepare next message     CSW025
      ** while we process the current one                                       CSW025
     C     *in01         ifeq      *off                                         CSW025
     C                   movel(p)  '*NEXT'       q@prompt                       CSW025
     C                   call      'QSNDDTAQ'    q@snddtaq                      CSW025
     C                   endif                                                  CSW025
                                                                                CSW025
      ** Pick up current message from data queue                                CSW025
     C                   call      'QRCVDTAQ'    q@rcvdtaq                      CSW025
                                                                                CSW025
      ** If message available attempt to send it                                CSW025
     C     q@sndref      ifne      '*NONE'                                      CSW025
     C     q@sndref      andne     '*ERROR'                                     CSW025
                                                                                CSW025
      ** Access PENDing message on file to lock                                 CSW025
     C                   movel     q@sndref      w@trn            16            CSW025
     C     w@trn         chain     mgorefl0                           50        CSW025
                                                                                CSW025
      ** Set dataq priority key                                                              BUG3189
     C     mtpy          ifeq      '940'                                                     BUG3189
     C     mtpy          oreq      '950'                                                     BUG3189
     C                   move      '90'          q@skey                                      BUG3189
     C                   else                                                                BUG3189
     C                   move      '10'          q@skey                                      BUG3189
     C                   end                                                                 BUG3189
      *                                                                                      BUG3189
      ** Validate if PAPER will be generated and system value should be Y                   MD048231
      ** to generate                                                                        MD048231
     C     NWRK          IFEQ      'PAPER'                                                  MD048231
     C     MMMPaper      ANDNE     'Y'                                                      MD048231
     C                   GOTO      DISCRDDQ                                                 MD048231
     C                   ENDIF                                                              MD048231
      **                                                                                    MD048231
      ** Message consists of                                                    CSW025
      ** - Meridian 1.7 header                                                  CSW025
      ** - message header = MGOREFPD data                                       CSW025
      ** - SWIFT II text                                                        CSW025
                                                                                CSW025
      ** Set the Meridian 1.7 header fields                                     CSW025
     C                   eval      RAMSGTYPE = 'Midas_SWIFT'                    CSW025
     C                   eval      RATGTSYS  = 'Midas'                          CSW025
                                                                                CSW025
      ** The message header and the SWIFT II text are formatted by the          CSW025
      ** compression program. They are received in q@msgbuf which is a          CSW025
      ** subfield of q@dqm.  This is a parameter in the q@rcvdtaq plist,        CSW025
      ** used on the call to QRCVDTAQ)                                          CSW025
     C                   EVAL      p@msgbuf = APMH17 + q@msgbuf                 CSW025
                                                                                CSW025
      ** Remove null byte                                                       CSW025
     C     w@null:' '    xlate     p@msgbuf      p@msgbuf                       CSW025
                                                                                CSW025
      ** Send message                                                           CSW025
     C                   eval      q@DQData = p@msgbuf                          CSW025
     C                   call      'QSNDDTAQ'    q@sndDQpl              99      CSW025
                                                                                CSW025
      ** Trace                                                                  CSW025
     C                   movel     '*PUT   '     PR@FN                          CSW025
     C                   movel     q@msgbuf      t@tdat                         CSW025
     C                   exsr      sr_trace                                     CSW025
                                                                                CSW025
      ** If send message failed, indicate abnormal end                          CSW025
     C                   if        *in99 = *on                                  CSW025
                                                                                CSW025
     C                   movel     'Y'           w@abnormal                     CSW025
     C                   movel     'DataQueue'   w0file                         CSW025
     C                   movel     'MEM6001'     w0msgd                         CSW025
     C                   movel     'MIDAS  '     w0msgf                         CSW025
     C                   movel     'Send message'w0key                          CSW025
     C                   movel     *blank        w0reas                         CSW025
     C                   z-add     201           w0ernb                         CSW025
                                                                                CSW025
     C                   endif                                                  CSW025
                                                                                CSW025
      ** Update message status                                                  CSW025
                                                                                CSW025
     C     DISCRDDQ      TAG                                                                MD048231
     C     w@abnormal    ifeq      'Y'                                          CSW025
      ** If error: to set on the PDE flag, in case the message was delivered    CSW025
     C                   movel     'Y'           MPDE                           CSW025
                                                                                CSW025
     C                   else                                                   CSW025
      ** If no error: to show as transmitted                                    CSW025
     C                   movel     '3'           MGSG                           CSW025
     C                   movel     'TRAN'        MGST                           CSW025
     C                   endif                                                  CSW025
                                                                                CSW025
     C                   movel     BJMRDT        LADT                           CSW025
     C                   TIME                    LATM                           CSW025
     C                   update    mgorefd0                                     CSW025
     C                   commit                                                 CSW025
                                                                                CSW025
      ** else (if no messages to send) wait for prompt/time-out                 CSW025
     C                   else                                                   CSW025
                                                                                CSW025
      * If Midas EoD processing is requested, the first time we get             CSW025
      * here all messages must have been sent so send the RunDate               CSW025
      * Synchronisation message just once.                                      CSW025
     C     CSW034        ifeq      'N'                                          CSW034
     C     mgde          orne      smgde                                        CSW034
     C                   if        p@eod = '*EOD'                               CSW025
     C                   exsr      sr_DQeod                                     CSW025
     C                   eval      p@eod = ' '                                  CSW025
     C                   endif                                                  CSW025
     C                   endif                                                  CSW034
                                                                                CSW025
     C                   callb     'MSC8011M'                                   CSW025
     C                   endif                                                  CSW025
     C                   enddo                                                  CSW025
                                                                                CSW025
      ** Pop subroutine                                                         CSW025
     C                   clear                   @STK(Q)                        CSW025
     C                   sub       1             Q                              CSW025
     C                   endsr                                                  CSW025
      /EJECT                                                                    CSW025
      **********************************************************************    CSW025
      * sr_DQeod       : Send EOD message to Data Queue                    *    CSW025
      * --------                                                           *    CSW025
      *                                                                    *    CSW025
      * Called by      : Mainline                                          *    CSW025
      *                                                                    *    CSW025
      * Calls          : QSNDDTAQ                                          *    CSW025
      *                                                                    *    CSW025
      **********************************************************************    CSW025
      *                                                                         CSW025
     C     sr_DQeod      begsr                                                  CSW025
      *                                                                         CSW025
      ** Push subroutine                                                        CSW025
     C                   add       1             Q                              CSW025
     C                   movel     'sr_DQeod'    @STK(Q)                        CSW025
                                                                                CSW025
      ** Message consists of                                                    CSW025
      ** - Meridian 1.7 header                                                  CSW025
      ** - Specific EOD text                                                    CSW025
      **         - Rundate and DateOfNextWorkingDay in 5A format                CSW025
                                                                                CSW025
      ** Set the Meridian 1.7 header fields                                     CSW025
     C                   eval      RAMSGTYPE = 'Rundate_Synch'                  CSW025
     C                   eval      RATGTSYS  = 'Midas'                          CSW025
                                                                                CSW025
      ** Convert Rundate & DNWD from 3P to 5A                                   CSW025
     C                   z-add     BJRDNB        BJRDNB5S                       CSW025
     C                   z-add     BJDNWD        BJDNWD5S                       CSW025
                                                                                CSW025
      ** Send the header, rundate, tommorows rundate and the system identifer                 220126
     C**********         EVAL      q@DQData = APMH17 + BJRDNB5A + BJDNWD5A             CSW025 220126
     C                   EVAL      q@DQData = APMH17 + BJRDNB5A + BJDNWD5A +                  220126
     C                                        LIBR                                            220126
                                                                                CSW025
      ** Send message                                                           CSW025
     C                   call      'QSNDDTAQ'    q@sndDQpl              99      CSW025
                                                                                CSW025
      ** Trace                                                                  CSW025
     C                   movel     '*PUT   '     PR@FN                          CSW025
     C                   movel     p@msgbuf      t@tdat                         CSW025
     C                   exsr      sr_trace                                     CSW025
                                                                                CSW025
      ** If send message failed, indicate abnormal end                          CSW025
     C                   if        *in99 = *on                                  CSW025
                                                                                CSW025
     C                   movel     'Y'           w@abnormal                     CSW025
     C                   movel     'DataQueue'   w0file                         CSW025
     C                   movel     'MEM6001'     w0msgd                         CSW025
     C                   movel     'MIDAS  '     w0msgf                         CSW025
     C                   movel     'Send EOD msg'w0key                          CSW025
     C                   movel     *blank        w0reas                         CSW025
     C                   z-add     203           w0ernb                         CSW025
                                                                                CSW025
     C                   else                                                   CSW025
                                                                                CSW025
      ** If send message succeeded, let Midas know processing can continue      CSW025
     C     *lock         in        mestat                                       CSW025
     C                   eval      MRDEOD = 'Y'                                 CSW025
     C                   out       mestat                                       CSW025
                                                                                CSW025
     C                   endif                                                  CSW025
                                                                                CSW025
      ** Pop subroutine                                                         CSW025
     C                   clear                   @STK(Q)                        CSW025
     C                   sub       1             Q                              CSW025
     C                   endsr                                                  CSW025
      /EJECT
      **********************************************************************
      * sr_in          : Get incoming messages and write to database       *
      * -----                                                              *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls            QMQM                                              *
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
      ** or API error.
      *
     C     *in01         doueq     *on
     C     REASON        orne      RCNONE
     C     REASON        andne     RC2033

      ** Get options: WAIT, CONVERT and ALLOW TRUNCATION.
      ** Note: the last of these options means that a message longer than
      ** the buffer length defined in this module (currently 1500 bytes)
      ** will be read and removed from the queue.  Any data in the message
      ** after the 1500th byte will be lost.
     C                   Z-ADD     GMWT          GMOPT
     C                   ADD       GMCONV        GMOPT
     C                   ADD       GMATM         GMOPT

      ** Set wait interval to 20 seconds
     C                   Z-ADD     20000         GMWI

      ** Perform get operation inside commitment control. Commitment
      ** boundary is after the message management file updates.
     C                   ADD       GMSYP         GMOPT

      ** MsgId and CorrelId are selectors cleared to ensure messages
      ** are processed in arrival/priority sequence
     C                   MOVEL     MINONE        MDMID
     C**********         MOVEL     MCSYTM        MDCID                               CSW039 BUG14494
     C**********         MOVEL     CINONE        MDCID                               BUG14494 257554
     C**********         MOVEL     MCSYTM        MDCID                               257554 AR214111
     C*****              MOVEL     CINONE        MDCID                                        CSW039

      ** Clear message buffer
     C                   clear                   q@msgbuf

      ** Get message
     C                   Z-ADD     MQGET         CID
     C                   CALL      'QMQM'
     C                   PARM                    CID               9 0
     C                   PARM                    HCONN             9 0
     C                   PARM                    HIN               9 0
     C                   PARM                    MQMD
     C                   PARM                    MQGMO
     C                   PARM      12000         p@msglen          9 0
     C                   PARM                    q@msgbuf
     C                   PARM                    MESLEN            9 0
     C                   PARM                    CCODE             9 0
     C                   PARM                    REASON            9 0

      ** Message starts after the API header block

     C                   clear                   p@msgbuf
     C**********         subst     q@msgbuf:HLEN p@msgbuf                                   BUG13405
     C                   Movel     q@msgbuf      p@msgbuf                                   BUG13405
      *
      ** Trace
     C                   movel     '*GET   '     PR@FN
     C                   movel     p@msgbuf      t@tdat
     C                   exsr      sr_trace
      *
      ** If receive message failed, indicate abnormal end
      *
     C     REASON        ifne      RCNONE
     C     REASON        andne     RC2033
     C                   movel     'Y'           w@abnormal
     C                   movel     'QMQM     '   w0file
     C                   movel     'MEM6001'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   movel     'Rcv message' w0key
     C                   movel     REASON        w0reas
     C                   z-add     102           w0ernb
     C                   else

      ** Else, if data received and no error

     C     REASON        ifne      RC2033
      *                                                                                       CSW209
      ** Scan message for Escape Sequence Translation                                         CSW209
     C     csw209        ifeq      'Y'                                                        CSW209
     C                   exsr      sr_esctr                                                   CSW209
     C                   endif                                                                CSW209
      *                                                                                       CSW209
     C**********         movel     p@msgbuf      APHEAD                                     MD023406
      *                                                                                     MD023406
     C                   clear                   w@msgbuf                                   MD023406
     C                   z-add     1             x                 5 0                      MD023406
     C                   movea     p@msgbuf      w@msgbuf(x)                                MD023406
      *                                                                                     MD023406
      ** Convert carriage return + line feed x'0d15 to x'0d25'                              MD023406
      *                                                                                     MD023406
     C     x             doueq     12000                                                    MD023406
     C                   movea     w@msgbuf(x)   @wk2              2                        MD023406
     C     @wk2          ifeq      w@altcrlf                                                MD023406
     C                   movea     w@crlf        w@msgbuf(x)                                MD023406
     C                   endif                                                              MD023406
     C                   add       1             x                                          MD023406
     C                   enddo                                                              MD023406
     C                   movea     w@msgbuf      p@msgbuf                                   MD023406
      *
     C     '{2:'         scan      p@msgbuf      p                 5 0
     C                   add       3             p
     C     1             subst     p@msgbuf:p    w@io              1
     C/COPY WNCPYSRC,MS6110MC10
      *
      ** Perform approriate process for Message, Report (ACK / NAK)
      ** or other (unexpected)
     C     w@io          caseq     'O'           sr_msg
     C     w@io          caseq     'I'           sr_rpt
     C                   cas                     sr_trash
     C                   endcs

     C                   endif
     C                   endif
      *
      ** Check whether termination has been requested
     C                   shtdn                                        01
      *
     C                   enddo
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT                                                                    CSW025
      **********************************************************************    CSW025
      * sr_DQin        : Get incoming Data Queue msgs and write to d/b     *    CSW025
      * -------                                                            *    CSW025
      *                                                                    *    CSW025
      * Called by      : Mainline                                          *    CSW025
      *                                                                    *    CSW025
      * Calls            QRCVDTAQ                                          *    CSW025
      *                  sr_msg                                            *    CSW025
      *                  sr_rpt                                            *    CSW025
      *                  sr_trash                                          *    CSW025
      *                                                                    *    CSW025
      **********************************************************************    CSW025
      *                                                                         CSW025
     C     sr_DQin       begsr                                                  CSW025
      *                                                                         CSW025
      ** Push subroutine                                                        CSW025
     C                   add       1             Q                              CSW025
     C                   movel     'sr_in'       @STK(Q)                        CSW025
      *                                                                         CSW025
      ** Access incoming data until termination requested by user,              CSW025
      ** or API error.                                                          CSW025
      *                                                                         CSW025
     C     *in01         doueq     *on                                          CSW025
     C     w@abnormal    oreq      'Y'                                          CSW025
                                                                                CSW025
      ** Clear message buffer                                                   CSW025
     C                   clear                   q@DQData                       CSW025
                                                                                CSW025
      ** Get message                                                            CSW025
     C                   call      'QRCVDTAQ'    q@rcvDQpl              99      CSW025
     C                   eval      p@msgbuf = q@DQData                          CSW025
                                                                                CSW025
      ** Trace                                                                  CSW025
     C                   movel     '*GET   '     PR@FN                          CSW025
     C                   movel     p@msgbuf      t@tdat                         CSW025
     C                   exsr      sr_trace                                     CSW025
                                                                                CSW025
      ** If receive message failed, indicate abnormal end                       CSW025
     C                   if        *in99 = *on                                  CSW025
     C                   movel     'Y'           w@abnormal                     CSW025
     C                   movel     'DataQueue'   w0file                         CSW025
     C                   movel     'MEM6001'     w0msgd                         CSW025
     C                   movel     'MIDAS  '     w0msgf                         CSW025
     C                   movel     'Rcv message' w0key                          CSW025
     C                   movel     REASON        w0reas                         CSW025
     C                   z-add     202           w0ernb                         CSW025
     C                   else                                                   CSW025
                                                                                CSW025
      ** Else, if no error                                                      CSW025
                                                                                CSW025
     C     '{2:'         scan      p@msgbuf      p                 5 0          CSW025
     C                   add       3             p                              CSW025
     C     1             subst     p@msgbuf:p    w@io              1            CSW025
                                                                                CSW025
      ** Perform appropriate process for Message, Report (ACK / NAK)            CSW025
      ** or other (unexpected)                                                  CSW025
     C     w@io          caseq     'O'           sr_msg                         CSW025
     C     w@io          caseq     'I'           sr_rpt                         CSW025
     C                   cas                     sr_trash                       CSW025
     C                   endcs                                                  CSW025
                                                                                CSW025
     C                   endif                                                  CSW025
                                                                                CSW025
      ** Check whether termination has been requested                           CSW025
     C                   shtdn                                        01        CSW025
                                                                                CSW025
     C                   enddo                                                  CSW025
                                                                                CSW025
      ** Pop subroutine                                                         CSW025
     C                   clear                   @STK(Q)                        CSW025
     C                   sub       1             Q                              CSW025
     C                   endsr                                                  CSW025
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
     C                   eval      w@f1 = p@msgbuf                                            CSW209
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
     C                   eval      p@msgbuf = w@f1                                            CSW209
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
      *                                                                                     AR976772
      ** Set up Century field                                                               AR976772
     C                   movel     MODE          cent              2                        AR976772
     C     cent          iflt      '72'                                                     AR976772
     C                   move      '20'          MODEC                                      AR976772
     C                   else                                                               AR976772
     C                   move      '19'          MODEC                                      AR976772
     C                   endif                                                              AR976772
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
      ** Prompt Incoming Message Management
     C                   callb     'MEC1024M'                           9090
     C                   parm      *blanks       p@rtcd            7
      *
      ***Update*received*network*information                                                AR989496
     C******dtaara       define                  medta                                      AR989496
     C******lock         in        medta                                                    AR989496
     C**********         movel     MOR           DAMOR                                      AR989496
     C**********         movel     MIR           DAMIR                                      AR989496
     C**********         out       medta
      *
     C                   endif
      *
      ** Commit transaction (message) : all data + index
     C                   commit
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
      ** If BIC code ends in 'XXX' then use default branch                                    252317
      **    and not found in the SDBRCHPD file                                                252317
     C                   if        *in80  = *off and                                          252317
     C                             w@brbr = 'XXX'                                             252317
     C                   move      dftbrch       BRCA                                         252317
     C                   end                                                                  252317
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
     C/COPY WNCPYSRC,MS6110MC15
     C                   endif
     C                   move      k@clikey      STID
      *
      ** Locate TRN
     C     ':20:'        scan      p@msgbuf      w@1                      65                  140532
     C     *in65         ifeq      *off                                                       140532
     C     ':20C:'       scan      p@msgbuf      w@1                      65                  140532
     C                   add       8             w@1                                          140532
     C                   endif                                                                140532
      *
      ** Scan for the end of the TRN
     C     w@crlf        scan      p@msgbuf:w@1  w@2               7 0
      *
      ** If that doesn't find it, try the alternative CR/LF encoding            CSW038
     C                   if        w@2 = 0                                      CSW038
     C     w@altcrlf     scan      p@msgbuf:w@1  w@2                            CSW038
     C                   endif                                                  CSW038
                                                                                CSW038
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
                                                                                             BUG4717
      ** Populate Output Date Century field                                                  BUG4717
     C                   MOVEL     '20'          MODEC                                       BUG4717
                                                                                              CTI004
      ** IF CTI004 is installed, check message type                                           CTI004
                                                                                              CTI004
     C                   IF        CTI004 =  'Y'                                              CTI004
     C                   CALL      'MS6200'                                                   CTI004
     C                   PARM      MTPY          PMTPY                                        CTI004
     C                   PARM      p@msgbuf      PMSGBUF                                      CTI004
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
      *                                                                                       CSW212
     C     MTPY          ifeq      '600'                                                      CSW212
     C                   movel     ':34'         w@stag                                       CSW212
     C                   else                                                                 CSW212
      *
      ** Find field :32a:
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
                                                                                CSW038
      ** If that doesn't find it, try the alternative CR/LF encoding            CSW038
     C                   if        w@2 = 0                                      CSW038
     C     w@altcrlf     scan      p@msgbuf:w@1  w@2                            CSW038
     C                   endif                                                  CSW038
                                                                                CSW038
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
     C                   movel     ':19'         w@stag                                       125554
     C     w@scan        scan      p@msgbuf      w@1                                          125554
     C                   add       2             w@1                                          125554
     C*                                                                                       125554
     C                   clear                   AMTS
     C                   add       4             w@1
     C     w@crlf        scan      p@msgbuf:w@1  w@2
                                                                                CSW038
      ** If that doesn't find it, try the alternative CR/LF encoding            CSW038
     C                   if        w@2 = 0                                      CSW038
     C     w@altcrlf     scan      p@msgbuf:w@1  w@2                            CSW038
     C                   endif                                                  CSW038
                                                                                CSW038
     C     w@2           sub       w@1           w@ln
     C     w@ln          subst     p@msgbuf:w@1  AMTS
      *
      ** Find field :30: and extract value date
     C                   movel     ':30'         w@stag                                       125554
     C     w@scan        scan      p@msgbuf      w@1                                          125554
     C                   add       2             w@1                                          125554
     C*                                                                                       125554
     C                   add       4             w@1
     C     6             subst     p@msgbuf:w@1  SVDT
      *
      ** Find field :32: and extract currency
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
     C                   movel     ':25'         w@stag                                       125554
     C     w@scan        scan      p@msgbuf      w@1                                          125554
     C                   add       2             w@1                                          125554
     C*                                                                                       125554
     C                   clear                   AMTS
     C                   add       4             w@1
     C     w@crlf        scan      p@msgbuf:w@1  w@2
                                                                                CSW038
      ** If that doesn't find it, try the alternative CR/LF encoding            CSW038
     C                   if        w@2 = 0                                      CSW038
     C     w@altcrlf     scan      p@msgbuf:w@1  w@2                            CSW038
     C                   endif                                                  CSW038
                                                                                CSW038
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
     C                   movel     ':34'         w@stag                                       125554
     C     w@scan        scan      p@msgbuf:w@1  w@1                                          125554
     C                   add       2             w@1                                          125554
      *
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
                                                                                CSW038
      ** If that doesn't find it, try the alternative CR/LF encoding            CSW038
     C                   if        w@2 = 0                                      CSW038
     C     w@altcrlf     scan      p@msgbuf:w@1  w@2                            CSW038
     C                   endif                                                  CSW038
                                                                                CSW038
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
      ** Access reference record for this message using TRN from field :20:
      ** if found
     C     ':20:'        scan      p@msgbuf      w@1                      78
     C/COPY WNCPYSRC,MS6110MC11
     C     *in78         ifeq      *on
      *
     C     w@crlf        scan      p@msgbuf:w@1  w@2
                                                                                CSW038
      ** If that doesn't find it, try the alternative CR/LF encoding            CSW038
     C                   if        w@2 = 0                                      CSW038
     C     w@altcrlf     scan      p@msgbuf:w@1  w@2                            CSW038
     C                   endif                                                  CSW038
                                                                                CSW038
     C/COPY WNCPYSRC,MS6110MC12
     C                   add       4             w@1
     C     w@2           sub       w@1           w@ln
     C     w@ln          subst(p)  p@msgbuf:w@1  w@trno
     C     w@trno        chain     mgorefd0                           70
     C     *in70         ifeq      *off
     C     TRNF          andne     *blanks
     C     TRNF          chain     mgorefd0                           70
     C                   endif
      *
      ** If original message still exists, write ACK / NAK details
     C     *in70         ifeq      *off
      *
      ** Find the ACK / NAK date and time in field {177:YYMMDDHHMM}
     C     '{177:'       scan      p@msgbuf      w@1
     C                   add       5             w@1
     C     6             subst     p@msgbuf:w@1  w@mode
     C                   movel     w@mode        MODE
     C                   add       6             w@1
     C     4             subst     p@msgbuf:w@1  w@motm
     C                   movel     w@motm        MOTM
      *
      ** Set up last action date and time and MIR
     C                   movel(p)  w@day         LADT
     C     w@month       lookup    tabmonn       tabmona                  77
     C     LADT          cat       tabmona:0     LADT
     C     LADT          cat       w@year:0      LADT
     C                   z-add     w@latm        LATM
      *
     C     22            subst     p@msgbuf:7    w@an_mir         22
     C                   movel(p)  MODE          MIR
     C     MIR           cat       w@an_mir:0    MIR
      *
      ** Find the Accept-Reject code in field {451:n}, and set up data
      ** and reference fields accordingly
     C     '{451:'       scan      p@msgbuf      w@1
     C                   add       5             w@1
     C     1             subst     p@msgbuf:w@1  w@acknak          1
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
     C     '{405:'       scan      p@msgbuf      w@1
     C                   add       5             w@1
     C     3             subst     p@msgbuf:w@1  MSE1
     C                   add       3             w@1
     C     3             subst     p@msgbuf:w@1  ELIN
     C                   endif
      *
      ** Output 1st record of ACK / NAK to MSMSI2PD and update
      ** reference
     C                   movel     p@msgbuf      MDTA
     C/COPY WNCPYSRC,MS6110MC13
     C                   write     msmsi2d0
     C/COPY WNCPYSRC,MS6110MC14
     C                   update    mgorefd0
      *
     C                   endif
     C                   endif
      *
      ** Commit transaction : (N)ACK data + reference file update
     C                   commit
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
      * sr_term        : Program termination                               *
      * -------                                                            *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : sr_close                                          *
      *                                                                    *
      **********************************************************************
      *
     C     sr_term       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_term'     @STK(Q)
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
      ** Close MQ series queue (if it was opened)
      *
     C     w@open        ifeq      'Y'

     C                   exsr      sr_close
     C     w@connect     ifeq      'Y'                                                        245310
     C                   exsr      sr_disconn                                                 245310
     C                   endif                                                                245310
     C                   endif
      *
      ** Perform abnormal termination processing if required:
      *
     C     w@abnormal    ifeq      'Y'
      *
      **  - print error report
     C     w@prtopn      ifne      'Y'
     C                   open      ms6110au
     C                   movel     'Y'           w@prtopn
     C                   endif
     C                   write     ms6110f1
     C                   write     ms6110f2
     C                   write     ms6110f3
     C                   close     ms6110au
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
      * sr_init        : Initialise program                                *
      * -------                                                            *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : sr_open                                           *
      *                  AOSARDR0                                          *                  CSW025
      *                                                                    *
      **********************************************************************
      *
     C     sr_init       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_init'     @STK(Q)
      *
      ** Define data areas
     C     *dtaara       define                  msstat
     C     *dtaara       define                  sdstat
     C/COPY WNCPYSRC,MS6110MC04
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
                                                                                CSW025
      * parameter lists for put/get to final Data Queues                        CSW025
     C     q@sndDQpl     plist                                                  CSW025
     C                   parm                    q@DQNameOut      10            CSW025
     C                   parm      '*LIBL'       q@DQLibl         10            CSW025
     C                   parm      12000         q@DQLength        5 0          CSW025
     C                   parm                    q@DQData      12000            CSW025
     C                   parm      4             q@klength         3 0                        CSW034
     C                   parm                    q@skey            4                          CSW034
                                                                                CSW025
     C     q@rcvDQpl     plist                                                  CSW025
     C                   parm                    q@DQNameIn       10            CSW025
     C                   parm      '*LIBL'       q@DQLibl                       CSW025
     C                   parm      12000         q@DQLength                     CSW025
     C                   parm                    q@DQData                       CSW025
     C                   parm      1200          q@DQwait          5 0
     C                   parm      'EQ'          q@korder          2                          CSW034
     C                   parm      2             q@klength         3 0                        CSW034
     C                   parm                    q@rkey            2                          CSW034
     C                   parm                    q@sndlen          3 0                        CSW034
     C                   parm                    q@sndinfo        45                          CSW034
      *
      ** Access SDSTAT for system prefix
     C                   in        sdstat
     C                   movel     LIBR          q@skey                                       244430
     C/COPY WNCPYSRC,MS6110MC05
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
                                                                                CSW025
      ** Check if the Data Queue export feature is present.                     CSW025
      **  If not, export is via an MQSeries queue.                              CSW025
     C                   CALLB     'AOSARDR0'                                   CSW025
     C                   PARM      *BLANKS       @RTCD                          CSW025
     C                   PARM      '*VERIFY'     @OPTN                          CSW025
     C                   PARM      'CSW025'      @SARD                          CSW025
     C     SCSARD        PARM      SCSARD        DSFDY                          CSW025
     C     @RTCD         IFEQ      *BLANKS                                      CSW025
     C                   MOVE      'Y'           CSW025            1            CSW025
     C                   ELSE                                                   CSW025
     C                   MOVE      'N'           CSW025                         CSW025
     C                   ENDIF                                                  CSW025
      *
      ** ... or not quite: if MMM (CSW025) is on, we check for CSW038;          CSW038
      ** if THAT is on we use MQSeries; but if it is off we use data            CSW038
      ** queues.                                                                CSW038
     C                   CALLB     'AOSARDR0'                                   CSW038
     C                   PARM      *BLANKS       @RTCD                          CSW038
     C                   PARM      '*VERIFY'     @OPTN                          CSW038
     C                   PARM      'CSW038'      @SARD                          CSW038
     C     SCSARD        PARM      SCSARD        DSFDY                          CSW038
     C     @RTCD         IFEQ      *BLANKS                                      CSW038
     C                   MOVE      'Y'           CSW038            1            CSW038
     C                   ELSE                                                   CSW038
     C                   MOVE      'N'           CSW038                         CSW038
     C                   ENDIF                                                  CSW038

     C                   CALLB     'AOSARDR0'                                   CSW034
     C                   PARM      *BLANKS       @RTCD                          CSW034
     C                   PARM      '*VERIFY'     @OPTN                          CSW034
     C                   PARM      'CSW034'      @SARD                          CSW034
     C     SCSARD        PARM      SCSARD        DSFDY                          CSW034
     C     @RTCD         IFEQ      *BLANKS                                      CSW034
     C                   MOVE      'Y'           CSW034            1            CSW034
     C                   ELSE                                                   CSW034
     C                   MOVE      'N'           CSW034                         CSW034
     C                   ENDIF                                                  CSW034
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
      ** Proceessing for *INCOMING mode
     C     p@io          ifeq      'I'
      *
     C/COPY WNCPYSRC,MS6110MC19
      ** Build arrays of SWIFT BIC+branch details v Midas branch code for
      ** use when assigning Midas branch to incoming messages (in sr_ix).
     C                   z-add     1             w@b               5 0
     C     *loval        setll     sdbrchl0
     C                   read      sdbrchl0                               50
     C     *in50         doweq     *off
     C*****w@b**         andle     99                                                         252317
     C     w@b           andle     999                                                        252317
     C                   movel     A8BRCD        br@midas(w@b)
     C                   movel(p)  w@brad        br@swift(w@b)
     C                   move      w@brbr        br@swift(w@b)
      ** Set default branch to be that of bank's internal customer                            252317
     C                   if        BJCUST = A8BICN                                            252317
     C                   movel     A8BRCD        dftbrch           3                          252317
     C                   end                                                                  252317
     C                   read      sdbrchl0                               50
     C                   add       1             w@b
     C                   enddo
     C/COPY WNCPYSRC,MS6110MC20
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
      *
      ** Get communication details from file
     C     p@mcid        chain(n)  MSMCIDL0                           51
     c     *in51         ifeq      *on
     C                   movel     'MSMCIDL0'    w0file
     C                   movel     p@mcid        w0key
     C                   z-add     04            w0ernb
     C                   movel     'MEM5003'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   exsr      srerr
     C                   endif

      ** Determine API Header record lengths

     C                   CALLB     'UTGETRCDLN'

      ** Return code
     C                   PARM                    ReturnCode       10
      ** Record length
     C                   PARM      *ZERO         HLEN              5 0
      ** File name
     C/COPY WNCPYSRC,MS6110MC06
     C                   PARM      'APHEADPD  '  FileName         10
     C/COPY WNCPYSRC,MS6110MC07
      ** File library
     C                   PARM      '*LIBL     '  FileLib          10

     C/COPY WNCPYSRC,MS6110MC08
     C                   ADD       1             HLEN
     C/COPY WNCPYSRC,MS6110MC09
      *
      ***If*CSW038*is*on*(we*are*sending*message*to*MMM*via*MQSeries)**                CSW038 250527
      ***then*we*need*the*length*of*the*Meridian*1.7*header*instead****                CSW038 250527
     C                   if        CSW038 = 'Y'                                               CSW038
                                                                                              CSW038
     C**********         CALLB     'UTGETRCDLN'                                        CSW028 250527
      ***Return*code***************************************************                CSW028 250527
     C**********         PARM                    ReturnCode       10                   CSW028 250527
      ** Record length*************************************************                CSW028 250527
     C**********         PARM      *ZERO         HLEN                                  CSW028 250527
      ** File name*****************************************************                CSW028 250527
     C**********         PARM      'APMH17PD  '  FileName         10                   CSW028 250527
      ** File library                                                                  CSW038 250527
     C**********         PARM      '*LIBL     '  FileLib          10                   CSW038 250527
                                                                                              CSW038
     C**********         ADD       1             HLEN                                  CSW038 250527
     C                   Z-ADD     1             HLEN                                         250527
     C                   endif                                                                CSW038

      ** Initialise failure flag, termination indicator, 'open'
      ** and 'server termination requested' flags
      ** also MQ open error flag as 'open' flag was used for two reasons        CSW025
     C                   movel     'N'           w@abnormal        1
     C                   movel     *off          *in01
     C                   movel     'N'           w@connect         1                          245310
     C                   movel     'N'           w@open            1
     C                   movel     'N'           w@srvr_trq        1
     C                   movel     'N'           w@MQConnErr       1                          245310
     C                   movel     'N'           w@MQOpenErr       1            CSW025

      ** Use default connection handle, and implicit connection
     C                   Z-ADD     HCDEFH        HCONN

      *                                                                                     MD051624
      ** Get Machine Date for TRAN value                                                    MD051624
      *                                                                                     MD051624
     C                   CALLB     'AOSVALR0'                                               MD051624
     C                   PARM      *BLANKS       PRTCD                                      MD051624
     C                   PARM      MachineDate   PSysVal01                                  MD051624
     C                   PARM                    PCurSet01                                  MD051624
     C                   PARM                    PSysVal02                                  MD051624
     C                   PARM                    PCurSet02                                  MD051624
     C                   PARM                    PSysVal03                                  MD051624
     C                   PARM                    PCurSet03                                  MD051624
     C                   PARM                    PSysVal04                                  MD051624
     C                   PARM                    PCurSet04                                  MD051624
     C                   PARM                    PSysVal05                                  MD051624
     C                   PARM                    PCurSet05                                  MD051624
     C                   PARM                    PSysVal06                                  MD051624
     C                   PARM                    PCurSet06                                  MD051624
     C                   PARM                    PSysVal07                                  MD051624
     C                   PARM                    PCurSet07                                  MD051624
     C                   PARM                    PSysVal08                                  MD051624
     C                   PARM                    PCurSet08                                  MD051624
     C                   PARM                    PSysVal09                                  MD051624
     C                   PARM                    PCurSet09                                  MD051624
     C                   PARM                    PSysVal10                                  MD051624
     C                   PARM                    PCurSet10                                  MD051624
      *                                                                                     MD051624
     C     PRTCD         IFEQ      *BLANKS                                                  MD051624
     C                   MOVEL     PCurSet01     WMACFLAG                                   MD051624
     C                   ENDIF                                                              MD051624
      ** Open MQ series queue
      **  only if the Data Queue export feature is not present.                 CSW025
     C                   if        CSW025 = 'N'                                 CSW025
     C                               OR CSW038 = 'Y'                            CSW038
      ** Access System Value                                                                MD048231
     C                                                                                      MD048231
     C                   EVAL      PSysVal02 = 'AllowPaperSendToMMM'                        MD048231
      ** If a Queue Manager is specified on SYSTEM VALUE MQQueueManager then                  245310
      ** connect to it and retain connection handle for other QMQM calls                      245310
      ** instead of using the default Queue Manager and connection                            245310
                                                                                              245310
     C                   CALLB     'AOSVALR0'                                                 245310
     C                   PARM      *BLANKS       PRtCd             7                          245310
     C                   PARM      MQManager     PSysVal01                                    245310
     C                   PARM                    PCurSet01                                    245310
     C                   PARM                    PSysVal02                                    245310
     C                   PARM                    PCurSet02                                    245310
     C                   PARM                    PSysVal03                                    245310
     C                   PARM                    PCurSet03                                    245310
     C                   PARM                    PSysVal04                                    245310
     C                   PARM                    PCurSet04                                    245310
     C                   PARM                    PSysVal05                                    245310
     C                   PARM                    PCurSet05                                    245310
     C                   PARM                    PSysVal06                                    245310
     C                   PARM                    PCurSet06                                    245310
     C                   PARM                    PSysVal07                                    245310
     C                   PARM                    PCurSet07                                    245310
     C                   PARM                    PSysVal08                                    245310
     C                   PARM                    PCurSet08                                    245310
     C                   PARM                    PSysVal09                                    245310
     C                   PARM                    PCurSet09                                    245310
     C                   PARM                    PSysVal10                                    245310
     C                   PARM                    PCurSet10                                    245310
                                                                                              245310
     C     PRtCd         IFNE      *BLANKS                                                    245310
     C                   MOVEL     PCurSet01     QMGR             48                          245310
     C                   exsr      sr_connect                                                 245310
     C                   z-add     HANDLE        HCONN                                        245310
     C                   endif                                                                245310
     C                   MOVEL     PCurSet02     MMMPaper                                   MD048231
     C                   exsr      sr_open
      **                                                                                    MD048231
      ** If CSW025 = 'Y' and CSW038 = 'N', Get system value for PAPER processing            MD048231
      **                                                                                    MD048231
     C                   ELSE                                                               MD048231
     C                   EVAL      PSysVal01 = 'AllowPaperSendToMMM'                        MD048231
     C                   CALLB     'AOSVALR0'                                               MD048231
     C                   PARM      *BLANKS       PRtCd             7                        MD048231
     C                   PARM                    PSysVal01                                  MD048231
     C                   PARM                    PCurSet01                                  MD048231
     C                   PARM                    PSysVal02                                  MD048231
     C                   PARM                    PCurSet02                                  MD048231
     C                   PARM                    PSysVal03                                  MD048231
     C                   PARM                    PCurSet03                                  MD048231
     C                   PARM                    PSysVal04                                  MD048231
     C                   PARM                    PCurSet04                                  MD048231
     C                   PARM                    PSysVal05                                  MD048231
     C                   PARM                    PCurSet05                                  MD048231
     C                   PARM                    PSysVal06                                  MD048231
     C                   PARM                    PCurSet06                                  MD048231
     C                   PARM                    PSysVal07                                  MD048231
     C                   PARM                    PCurSet07                                  MD048231
     C                   PARM                    PSysVal08                                  MD048231
     C                   PARM                    PCurSet08                                  MD048231
     C                   PARM                    PSysVal09                                  MD048231
     C                   PARM                    PCurSet09                                  MD048231
     C                   PARM                    PSysVal10                                  MD048231
     C                   PARM                    PCurSet10                                  MD048231
                                                                                            MD048231
     C                   IF        PrtCd = *BLANKS                                          MD048231
     C                   MOVEL     PCurSet01     MMMPaper                                   MD048231
     C                   ENDIF                                                              MD048231
     C                   endif                                                  CSW025
                                                                                CSW025
      ** If the Data Queue export feature is present:                           CSW025
     C                   if        CSW025 = 'Y'                                 CSW025
                                                                                CSW025
      **  - set up the 10A in the PLISTs from the 50A D/B field                 CSW025
     C                   if        p@io = 'I'                                   CSW025
     C                   movel     MCMQQN        q@DQNameIn                     CSW025
     C                   else                                                   CSW025
     C                   movel     MCMQQN        q@DQNameOut                    CSW025
     C                   endif                                                  CSW025
                                                                                CSW025
     C                   endif                                                  CSW025
                                                                                              CTI004
     C                   CALL      'AOSARDR0'                                                 CTI004
     C                   PARM      *BLANKS       PRTCD                                        CTI004
     C                   PARM      '*VERIFY'     POPTN                                        CTI004
     C                   PARM      'CTI004'      PSARD                                        CTI004
     C     SCSARD        PARM      SCSARD        DSFDY                                        CTI004
                                                                                              CTI004
     C                   IF        PRTCD = *BLANKS                                            CTI004
     C                   EVAL      CTI004 = 'Y'                                               CTI004
     C                   ELSE                                                                 CTI004
     C                   EVAL      CTI004 = 'N'                                               CTI004
     C                   ENDIF                                                                CTI004
      *
     C**********         movel     MCSYTM        wk10             10                  CSW034 BUG3189
     C*****wk10*         chain     HOSTSYSTL2                                         CSW034 BUG3189
     C                   If        CSW038 = 'N'                                             BUG12318
     C                   Call      'RTVNODEREF'                                              BUG3189
     C                   Parm      MCSYTM        HostID            2                         BUG3189
     C                   Parm                    noderef           2 0                       BUG3189
      *                                                                                      BUG3189
     C                   movel     noderef       q@skey                                       CSW034
     C**********         move      10            q@skey                               CSW034 BUG3189
      *                                                                                       CSW034
     C                   move      MCSYTM        q@rkey                                       CSW034
     C                   EndIf                                                              BUG12318
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT                                                                                  245310
      **********************************************************************                  245310
      * sr_connect     : Connect to Queue Manager                          *                  245310
      * ----------                                                         *                  245310
      *                                                                    *                  245310
      * Called by      : sr_init                                           *                  245310
      *                                                                    *                  245310
      * Calls          : QMQM                                              *                  245310
      *                                                                    *                  245310
      **********************************************************************                  245310
      *                                                                                       245310
     C     sr_connect    begsr                                                                245310
      *                                                                                       245310
      ** Push subroutine                                                                      245310
     C                   add       1             Q                                            245310
     C                   movel     'sr_connect'  @STK(Q)                                      245310
                                                                                              245310
      ** Connect to queue manager                                                             245310
                                                                                              245310
     C                   CALL      'QMQM'                                                     245310
     C                   PARM      MQCONN        CID               9 0                        245310
     C                   PARM      QMGR          QMNAME           48                          245310
     C                   PARM      *ZERO         HANDLE            9 0                        245310
     C                   PARM      *ZERO         OCODE             9 0                        245310
     C                   PARM      *ZERO         REASON            9 0                        245310
      *                                                                                       245310
      ** Trace                                                                                245310
     C                   movel     '*CONN  '     PR@FN                                        245310
     C                   exsr      sr_trace                                                   245310
                                                                                              245310
      ** If connection failed, indicate abnormal end                                          245310
                                                                                              245310
     C     REASON        IFNE      RCNONE                                                     245310
     C     REASON        andne     RC2002                                                     245310
     C                   movel     'Y'           w@abnormal                                   245310
     C                   movel     'QMQM     '   w0file                                       245310
     C                   movel     'MEM6001'     w0msgd                                       245310
     C                   movel     'MIDAS  '     w0msgf                                       245310
     C                   movel     'Connect   '  w0key                                        245310
     C                   movel     REASON        w0reas                                       245310
     C                   z-add     105           w0ernb                                       245310
     C                   movel     'Y'           W@MQConnErr                                  245310
                                                                                              245310
      ** If no failure, identify successful connect                                           245310
                                                                                              245310
     C                   else                                                                 245310
     C                   movel     'Y'           w@connect                                    245310
     C                   endif                                                                245310
      *                                                                                       245310
      ** Pop subroutine                                                                       245310
     C                   clear                   @STK(Q)                                      245310
     C                   sub       1             Q                                            245310
     C                   endsr                                                                245310
      /EJECT
      **********************************************************************
      * sr_open        : Open MQ series queue                              *
      * -------                                                            *
      *                                                                    *
      * Called by      : sr_init                                           *
      *                                                                    *
      * Calls          : QMQM                                              *
      *                                                                    *
      **********************************************************************
      *
     C     sr_open       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_open'     @STK(Q)
     C/COPY WNCPYSRC,MS6110MC16

      ** Queue manager name                                                     CSW038
     C     MCMQMN        ifne      *Blank                                       CSW038
     C                   MOVEL     MCMQMN        ODMN             48            CSW038
     C                   endif                                                  CSW038
                                                                                CSW038
      ** Connect to the queue manager; we have to do this explicitly            CSW038
      ** now, in order to support non-default queue managers.                   CSW038
     C                   Z-ADD     MQCONN        CID                            CSW038
     C                   CALL      'QMQM'                                       CSW038
     C                   PARM                    CID               9 0          CSW038
     C                   PARM                    MCMQMN                         CSW038
     C                   PARM                    HCONN             9 0          CSW038
     C                   PARM                    OCODE             9 0          CSW038
     C                   PARM                    REASON            9 0          CSW038
                                                                                CSW038
      ** If connect failed, indicate abnormal end                               CSW038
                                                                                CSW038
     C     REASON        IFNE      RCNONE                                       CSW038
     C                   movel     'Y'           w@abnormal                     CSW038
     C                   movel     'QMQM     '   w0file                         CSW038
     C                   movel     'MEM6001'     w0msgd                         CSW038
     C                   movel     'MIDAS  '     w0msgf                         CSW038
     C                   movel     'Conn Mgr  '  w0key                          CSW038
     C                   movel     REASON        w0reas                         CSW038
     C                   z-add     103           w0ernb                         CSW038
     C                   movel     'Y'           W@MQOpenErr                    CSW038
     C                   exsr      sr_term                                      CSW038
     C                   endif                                                  CSW038
                                                                                CSW038
      ** Queue name
     C                   MOVEL     MCMQQN        ODON             48

      ** Open queue for INPUT

     C     p@io          ifeq      'I'

      ** Open options: INPUT and FAIL_IF_QUIESCING
     C     OOINPQ        ADD       OOFIQ         OPTS

      ** Open queue for OUTPUT

     C                   else

      ** Open options: OUTPUT and FAIL_IF_QUIESCING
     C     OOOUT         ADD       OOFIQ         OPTS
     C                   endif
                                                                                              242607
      ** Clear Q-Manager so it can use clustered queues / remote Q-manager as well            242607
     C                   MOVE      *BLANKS       ODMN                                         242607

      ** Open queue
     C                   Z-ADD     MQOPEN        CID
     C                   CALL      'QMQM'
     C                   PARM                    CID               9 0
     C                   PARM                    HCONN             9 0
     C                   PARM                    MQOD
     C                   PARM                    OPTS              9 0
     C                   PARM                    HIN               9 0
     C                   PARM                    OCODE             9 0
     C                   PARM                    REASON            9 0
      *
      ** Trace
     C                   movel     '*OPEN  '     PR@FN
     C                   exsr      sr_trace

      ** If open queue failed, indicate abnormal end

     C     REASON        IFNE      RCNONE
     C                   movel     'Y'           w@abnormal
     C                   movel     'QMQM     '   w0file
     C                   movel     'MEM6001'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   movel     'Open queue'  w0key
     C                   movel     REASON        w0reas
     C                   z-add     103           w0ernb
     C                   movel     'Y'           W@MQOpenErr                    CSW025

      ** If no failure, identify successful open

     C                   else
     C                   movel     'Y'           w@open
     C                   endif
     C/COPY WNCPYSRC,MS6110MC17
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_close       : Close MQ series queue                             *
      * --------                                                           *
      *                                                                    *
      * Called by      : sr_term                                           *
      *                                                                    *
      * Calls          : QMQM                                              *
      *                                                                    *
      **********************************************************************
      *
     C     sr_close      begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_close'    @STK(Q)

      ** Close options: NONE
     C                   Z-ADD     CONONE        OPTS

      ** Close queue
     C                   Z-ADD     MQCLOS        CID
     C                   CALL      'QMQM'
     C                   PARM                    CID               9 0
     C                   PARM                    HCONN             9 0
     C                   PARM                    HIN               9 0
     C                   PARM                    OPTS              9 0
     C                   PARM                    CCODE             9 0
     C                   PARM                    REASON            9 0
      *
      ** Trace
     C                   movel     '*CLOSE '     PR@FN
     C                   exsr      sr_trace

      ** If close queue failed, indicate abnormal end

     C     REASON        IFNE      RCNONE
     C                   movel     'Y'           w@abnormal
     C                   movel     'QMQM     '   w0file
     C                   movel     'MEM6001'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   movel     'Close queue' w0key
     C                   movel     REASON        w0reas
     C                   z-add     104           w0ernb
     C                   endif
     C/COPY WNCPYSRC,MS6110MC18
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT                                                                                  245310
      **********************************************************************                  245310
      * sr_disconn     : Disconnect from Queue Manager                     *                  245310
      * ----------                                                         *                  245310
      *                                                                    *                  245310
      * Called by      : sr_term                                           *                  245310
      *                                                                    *                  245310
      * Calls          : QMQM                                              *                  245310
      *                                                                    *                  245310
      **********************************************************************                  245310
      *                                                                                       245310
     C     sr_disconn    begsr                                                                245310
      *                                                                                       245310
      ** Push subroutine                                                                      245310
     C                   add       1             Q                                            245310
     C                   movel     'sr_disconn'  @STK(Q)                                      245310
                                                                                              245310
      ** Disconnect from Queue Manager                                                        245310
                                                                                              245310
     C                   CALL      'QMQM'                                                     245310
     C                   PARM      MQDISC        CID               9 0                        245310
     C                   PARM                    HCONN             9 0                        245310
     C                   PARM      *ZERO         OCODE             9 0                        245310
     C                   PARM      *ZERO         REASON            9 0                        245310
      *                                                                                       245310
      ** Trace                                                                                245310
     C                   movel     '*DISC  '     PR@FN                                        245310
     C                   exsr      sr_trace                                                   245310
                                                                                              245310
      ** If connection failed, indicate abnormal end                                          245310
                                                                                              245310
     C     REASON        IFNE      RCNONE                                                     245310
     C                   movel     'Y'           w@abnormal                                   245310
     C                   movel     'QMQM     '   w0file                                       245310
     C                   movel     'MEM6001'     w0msgd                                       245310
     C                   movel     'MIDAS  '     w0msgf                                       245310
     C                   movel     'Disconnect'  w0key                                        245310
     C                   movel     REASON        w0reas                                       245310
     C                   z-add     106           w0ernb                                       245310
     C                   endif                                                                245310
      *                                                                                       245310
      ** Pop subroutine                                                                       245310
     C                   clear                   @STK(Q)                                      245310
     C                   sub       1             Q                                            245310
     C                   endsr                                                                245310
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
**CTDATA cpy@
(c) Finastra International Limited 2001
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
