000100210720     H DEBUG
000200210720     H COPYRIGHT('(c) Finastra International Limited 2002')
000300210720      *****************************************************************
000400210720/*STD *  RPGBASEMOD                                                   *
000500210720/*EXI *  ALWNULL(*USRCTL)                                             *                       CSW034
000600210720/*EXI *  TEXT('Midas MS Midas/SWIFT Meridian communication')          *
000700210720      *****************************************************************
000800210720      *                                                               *
000900210720      *  Midas - Midas SWIFT                                          *
001000210720      *                                                               *
001100210720      *  MS6110M - Midas/SWIFT Meridian communications                *
001200210720      *                                                               *
001300210720      ***Function:**This*program*effects*communications*between*the****         CSW025
001400210720      **************Midas/SWIFT*module*and*a*Meridian*MQ*Series*Queue**         CSW025
001500210720      *****************************************************************         CSW025
001600210720      **************It*is*used*for*both*incoming*and*outgoing**********         CSW025
001700210720      **************messages.*If*used*to*send*outgoing*messages********         CSW025
001800210720      **************a*server*job*(MS_M2M_SRV)*should*be*submitted******         CSW025
001900210720      **************for*each*instance*to*format*them.******************         CSW025
002000210720      *  Function:  This program effects communication between Midas  *         CSW025
002100210720      *             and Meridian using Data Queues or MQSeries Queues *         CSW025
002200210720      *                                                               *         CSW025
002300210720      *             It is used for both incoming and outgoing         *         CSW025
002400210720      *             messages. If used to send outgoing messages       *         CSW025
002500210720      *             a server job (MS_M2M_SRV) should be submitted     *         CSW025
002600210720      *             for each instance to format them.                 *         CSW025
002700210720      *                                                               *
002800210720      *  Called By: MSC6110 - Midas/SWIFT Meridian communications     *
002900210720      *                                                               *
003000210720      *  (c) Finastra International Limited 2001                      *
003100210720      *                                                               *
003101210720      *  Last Amend No. MD058137           Date 18May21               *
003200210720      *  Prev Amend No. MD041126           Date 04May20               *
003300210720      *                 MD051624           Date 23Sep20               *
003400210720      *                 AR989496           Date 13Jun12               *
003500210720      *                 CSD102             Date 08Jan19               *
003600210720      *                 MD048231           Date 17Jan18               *
003700210720      *                 MD046248           Date 27Oct17               *
003800210720      *                 AR214111           Date 26Jun15               *
003900210720      *                 250527             Date 19Aug14               *
004000210720      *                 251373             Date 30Jan08               *
004100210720      *                 MD023406           Date 12Nov13               *
004200210720      *                 AR976772           Date 23May12               *
004300210720      *                 CSW212             Date 03May12               *
004400210720      *                 252317             Date 15Feb08               *
004500210720      *                 CER059             Date 19Jul10               *
004600210720      *                 BUG21921           Date 26Jan09               *
004700210720      * Bank Fusion Midas 1.4 Base -----------------------------------*
004800210720      *                 CSW209             Date 01Apr09               *
004900210720      *                 257554             Date 05Nov08               *
005000210720      * Midas Plus 1.4 Base 04 ---------------------------------------*
005100210720      *                 246522             Date 23Mar07               *
005200210720      *                 BUG14494           Date 08Aug07               *
005300210720      *                 245310             Date 30Jan07               *
005400210720      *                 244430             Date 04Jan07               *
005500210720      *                 BUG13405           Date 23Feb07               *
005600210720      * Midas Plus 1.3 ----------- Base ------------------------------*
005700210720      *                 242607             Date 22Aug06               *
005800210720      *                 BUG12318           Date 04Nov06               *
005900210720      *                 CSD027             Date 09Dec05               *
006000210720      *                 CSW039             Date 15Sep05               *
006100210720      *                 CSW038             Date 13Apr05               *
006200210720      *                 CSW037A            Date 02May05               *
006300210720      *                 BUG6198            Date 04Apr05               *
006400210720      *                 CSD025             Date 11Jan05               *
006500210720      *                 CSW037             Date 15Dec04               *
006600210720      *                 CSW036             Date 15Dec04               *
006700210720      *                 BUG4717            Date 03Dec04               *
006800210720      *                 BUG3189            Date 10Jun04               *
006900210720      *                 CTI004             Date 12Apr04               *
007000210720      *                 CSW034             Date 09Jan04               *
007100210720      *                 220126             Date 29Jul03               *
007200210720      *                 CRE008             Date 23May02               *
007300210720      * Midas Release 4.01 -------------------------------------------*
007400210720      *                 CSW025             Date 15Apr02               *
007500210720      * Midas Release 4 --------------- Base -------------------------*
007600210720      * Midas DBA 3.04 -----------------------------------------------*
007700210720      *                 CDL008             Date 02May00               *
007800210720      * Midas DBA 3.03 -----------------------------------------------*
007900210720      *                 184427             DATE 11Oct00               *
008000210720      *                 184013             DATE 11Oct00               *
008100210720      * Midas DBA 3.02 -----------------------------------------------*
008200210720      *                 CSW017 *CREATE     Date 11Feb99               *
008300210720      *                                                               *
008400210720      *---------------------------------------------------------------*
008500210720      *                                                               *
008501210720      *  MD058137 - Midas is not generating unique MQ MessageID if    *
008502210720      *             via MGOREF message generation                     *
008600210720      *  MD041126 - Certify WebSphere MQ 9 with Midas product line    *
008700210720      *           - Applied for MD055614.                             *
008800210720      *  MD051624 - MT940's msgs found in the Outstanding Message     *
008900210720      *             Details Enquiry Screen are dated incorrectly.     *
009000210720      *           - Introduced system value 'MachineDateforTRAN' to   *
009100210720      *             retrieved the machine time.                       *
009200210720      *  AR989496 - Remove redundant code related to dtaara/MEDTA     *
009300210720      *           - Causes DBase Error in MS_MED2MID job              *
009400210720      *           - (Child:AR989497)                                  *
009500210720      *  CSD102 - Password Length Extension (Recompile)               *
009600210720      *  MD048231 - Removed/Changed fix 251373 in order to process    *
009700210720      *             PAPER network messages using MQ queue             *
009800210720      *  MD046248 - Finastra Rebranding                               *
009900210720      *  AR214111 - Incoming messages were not retrieved properly by  *
010000210720      *             MidasPlus. Reveresed part of 257554 to remove the *
010100210720      *             checking of the zone as the incoming message does *
010200210720      *             not have this information.                        *
010300210720      *           - Applied for MD034610.                             *
010400210720      *  250527 - When messages are passed from MMM via MQ Series set *
010500210720      *           header length to '1'. Applied fix 250335.           *
010600210720      *  251373 - Do not process 'PAPER' messages coming from         *
010700210720      *           MidasPlus.                                          *
010800210720      *  MD023406 - Convert carriage return + line x'0D15' to x0D25'. *
010900210720      *           - Ignore header on incoming message.                *
011000210720      *  AR976772 - Value date century is not populated for all types *
011100210720      *  CSW212 - SWIFT 2012 Changes                                  *
011200210720      *  252317 - Increase branches array size from 99 to 999.        *
011300210720      *           If BIC code ends in 'XXX' and BIC is not found in   *
011400210720      *           SDBRCHPD then use default branch                    *
011500210720      *           (i.e. branch of bank's internal customer)           *
011600210720      *  CER059 - German Feature Upgrade to Delhi                     *
011700210720      *  BUG21921 - Apply fix 20658 ; fix was applied through         *
011800210720      *             bug 257554                                        *
011900210720      *  CSW209 - SWIFT 2009 Changes                                  *
012000210720      *  257554 - Reversed BUG14494.                                  *
012100210720      *  246522 - Applied 1.2 core fix 243388.                        *
012200210720      *  243388 - Don't start with the buffer assuming a header of    *
012300210720      *           HLEN length.                                        *
012400210720      *  BUG14494 - Inward Funds Transfer missing                     *
012500210720      *  245310 - Remove assumption that a default queue manager      *
012600210720      *           exists and should be used                           *
012700210720      *  244430 - Call RTVNODEREF when CSW038 is off.                 *
012800210720      *  BUG13405 - Applied fix 243388                                *
012900210720      *  242607 - Change to work with clustered queues / remote QMGR. *
013000210720      *  BUG12318 - Remove call to RTVNODEREF when CSW038 is ON.      *
013100210720      *  CSD027 - Conversion Of Customer Number to Alpha              *
013200210720      *  CSW039 - Add System/Priority to Correlation ID               *
013300210720      *  CSW038 - Change to allow communication with MMM using        *
013400210720      *           MQSeries instead of data queues.  This change       *
013500210720      *           takes advantage of the fact that MQSeries support   *
013600210720      *           was already present, but reworks it so that         *
013700210720      *           the correct message header type is used (the        *
013800210720      *           existing support was for the MINT Interface).  It   *
013900210720      *           also attempts to allow for the alternative CR/LF    *
014000210720      *           format that is sometimes found in iSeries           *
014100210720      *           SWIFT messages.  Further, the option to use         *
014200210720      *           a queue manager other than the default one was      *
014300210720      *           added, and EOD messages, if requested, are now      *
014400210720      *           sent to the relevant MQSeries queue, if we are      *
014500210720      *           running in that mode.                               *
014600210720      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
014700210720      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
014800210720      *  CSD025 - Customer De-Activation                              *
014900210720      *  CSW037 - Additional Field Data on MT300/MT320                *
015000210720      *  CSW036 - Dual SWIFT BIC held on Client Details               *
015100210720      *  BUG4717- Messages from MMM are dropped too early.            *
015200210720      *  BUG3189- Apply keyed data queue changes for CSW034.          *
015300210720      *  CTI004 - MidasPlus-TI Integration Enhancements               *
015400210720      *           Routing Swift Messages                              *
015500210720      *  CSW034 - Midas Message Manager Global Processing             *
015600210720      *  220126 - Send header rundate next rundate & system id        *
015700210720      *  CRE008 - Cash Management                                     *
015800210720      *           Here, add type 103 in TABTYP to extract             *
015900210720      *           date and amount in MSIXI2PD                         *
016000210720      *  CSW025 - Midas Message Manager                               *
016100210720      *           - Send messages to Meridian Link via Data Queue     *
016200210720      *   CDL008 - Continuous Linked Settlement (Recompiled MGOREFPD) *
016300210720      *  184427 - Add MT340s and MT360s                               *
016400210720      *  184013 - Swift 2000 get correct date format from 30V         *
016500210720      *  CSW017 - Midas/Swift Meridian interface                      *
016600210720      *                                                               *
016700210720      *****************************************************************
016800210720      *                                                               *
016900210720      *  Notes:                                                       *
017000210720      *  ------                                                       *
017100210720      *                                                               *
017200210720      *    o  This module uses the QMQM API to exchange messages,     *
017300210720      *       ACKs and NAKs with Meridian MQ series queues.           *
017400210720      *                                                               *
017500210720      *****************************************************************
017600210720      /EJECT
017700210720     FMSMCIDL0  UF   E           K disk    infsr(srfile)
017800210720     FMGOREFL0  UF   E           K disk    infsr(srfile)
017900210720     F                                     commit
018000210720     FMGOMSGPD  IF   E           K disk    infsr(srfile)
018100210720     FMSMSI2L9  IF   E           K disk    infsr(srfile)
018200210720     F                                     rename(msmsi2d0:msmsi2d9)
018300210720     F/COPY WNCPYSRC,MS6110MF01
018400210720     FSDBRCHL0  IF   E           K disk    infsr(srfile)
018500210720     F/COPY WNCPYSRC,MS6110MF02
018600210720     FSDCUSTL7  IF   E           K disk    infsr(srfile)
018700210720     FMSMSI2PD  O    E           K disk    infsr(srfile)
018800210720     F                                     commit
018900210720     FMSIXI2PD  O    E           K disk    infsr(srfile)
019000210720     F                                     commit
019100210720     FMS6110AU  O    E             printer infsr(srfile)
019200210720     F                                     oflind(*in66)
019300210720     F                                     usropn
019400210720     F***HOSTSYSTL2IF***E           K disk                                            CSW034 BUG3189
019500210720      /EJECT
019600210720      /COPY MSCPYSRC,SRERRD
019700210720      *                                                                                       245310
019800210720      ** +--------------------------------------+                                             245310
019900210720      ** ¦ Manually included D-specs            ¦                                             245310
020000210720      ** ¦ =========================            ¦                                             245310
020100210720      ** +--------------------------------------+                                             245310
020200210720      *                                                                                       245310
020300210720      ** +--------------------------------------+                                             245310
020400210720      ** ¦ Named constants                      ¦                                             245310
020500210720      ** ¦ ===============                      ¦                                             245310
020600210720      ** +--------------------------------------+                                             245310
020700210720      *                                                                                       245310
020800210720      * Constant to hold input parameter for AOSVALR0.                                        245310
020900210720     D MQManager       C                   Const('MQQueueManagerMMM')                         245310
021000210720     D MachineDate     C                   Const('MachineDateforTRAN')                      MD051624
021100210720     D cpy@            S             80    dim(1) ctdata perrcd(1)
021200210720      ** Array containing Copyright statement
021300210720      *
021400210720     D*tabtyp**********S              3    dim(15) ctdata perrcd(1)             184427
021500210720     D*tabcas**********S              1    dim(15) alt(tabtyp)                  184427
021600210720     D*tabtyp**********S              3    dim(20) ctdata perrcd(1)      184427 CRE008
021700210720     D*tabcas**********S              1    dim(20) alt(tabtyp)           184427 CRE008
021800210720     D*tabtyp**********S              3    dim(21) ctdata perrcd(1)                    CRE008 CSW212
021900210720     D*tabcas**********S              1    dim(21) alt(tabtyp)                         CRE008 CSW212
022000210720     D tabtyp          S              3    dim(23) ctdata perrcd(1)                           CSW212
022100210720     D tabcas          S              1    dim(23) alt(tabtyp)                                CSW212
022200210720      ** Message type specific processes
022300210720      *
022400210720     D tabty2          S              3    dim(1) ctdata perrcd(1)                            CSW212
022500210720     D tabamc          S             10    dim(1) alt(tabty2)                                 CSW212
022600210720      ** Message tag and qualifier for amount/currency                                        CSW212
022700210720      *                                                                                       CSW212
022800210720     D tabty3          S              3    dim(1) ctdata perrcd(1)                            CSW212
022900210720     D tabdat          S             10    dim(1) alt(tabty3)                                 CSW212
023000210720      ** Message tag and qualifier for value date                                             CSW212
023100210720      *                                                                                       CSW212
023200210720     D tabmonn         S              2    dim(12) ctdata perrcd(1)
023300210720     D tabmona         S              3    dim(12) alt(tabmonn)
023400210720      ** Month code by month number (eg. 01 JAN)
023500210720      *
023600210720     D ar1             S              4    dim(14) ctdata perrcd(1)                           CSW209
023700210720     D ar2             S              1    dim(14) alt(ar1)                                   CSW209
023800210720      ** Escape Sequence Translation Array                                                    CSW209
023900210720      *                                                                                       CSW209
024000210720     D*br@midas*       S              3    dim(99)                                            252317
024100210720     D*br@swift*       S             11    dim(99)                                            252317
024200210720     D br@midas        S              3    dim(999)                                           252317
024300210720     D br@swift        S             11    dim(999)                                           252317
024400210720      ** Midas branch code v SWIFT branch code
024500210720      *
024600210720     D w@msgbuf        S              1    DIM(12000)                                       MD023406
024700210720      ** message buffer for conversion of carriage return + line feed                       MD023406
024800210720      *                                                                                     MD023406
024900210720     D w@b2dta         DS            46
025000210720     D  w@mtpy                 1      3
025100210720     D  w@96n                  1      2
025200210720     D  tme                    4      7
025300210720     D  MIR                    8     35
025400210720     D  w@sndad               14     21
025500210720     D  w@sndbr               23     25
025600210720     D  MODE                  36     41  0
025700210720     D  MOTM                  42     45  0
025800210720     D  w@mpry                46     46
025900210720      ** Split up Block 2 of incoming message
026000210720      *
026100210720     D                 DS
026200210720     D  MOR                    1     28
026300210720     D  w@mord                 1      6
026400210720     D  w@dstad                7     14
026500210720     D  w@dstbr               16     18
026600210720     D  w@morr                 7     28
026700210720      ** Message Ouput Reference (MOR)
026800210720      *
026900210720     D                 DS
027000210720     D  A8BTID                 1     12
027100210720     D  w@brad                 1      8
027200210720     D  w@brbr                10     12
027300210720      ** Split up branch TID
027400210720     D/COPY WNCPYSRC,MS6110MD01
027500210720      *
027600210720     D                 DS
027700210720     D  w@mode                 1      6
027800210720     D  w@year                 1      2
027900210720     D  w@month                3      4
028000210720     D  w@day                  5      6
028100210720      ** Message output date
028200210720      *
028300210720     D                 DS
028400210720     D  w@latm                 1      6  0
028500210720     D  w@motm                 1      4
028600210720     D  w@zz                   5      6    inz('00')
028700210720      ** Message output time and last action time
028800210720      *
028900210720     D                 DS
029000210720     D  k@clikey               1     12
029100210720     D  k@cliad                1      8
029200210720     D  k@clibr                9     11
029300210720      ** Key for access to Customer Details
029400210720      *
029500210720     D dsfdy         E DS                  extname(DSFDY)
029600210720      ** Data Structures used by access objects
029700210720      *
029800210720     D sdbank        E DS                  extname(SDBANKPD)
029900210720      ** Bank details data area
030000210720      *
030100210720     D sdmmod        E DS                  extname(SDMMODPD)
030200210720      ** Bank details data area
030300210720      *
030400210720     D medta         E DS                  extname(MEDTA)
030500210720      ** Message Management data area
030600210720      *
030700210720     D  msstat       E DS                  extname(MSSTAT)
030800210720     Dren@zz53       E                     extfld(ZZ053)                                      140532
030900210720      ** Midas/SWIFT Direct Link status data area
031000210720      *
031100210720                                                                                CSW025
031200210720     D  mestat       E DS                  extname(MESTAT) dtaara(MESTAT)       CSW025
031300210720      ** Midas Message Management status data area                              CSW025
031400210720                                                                                CSW025
031500210720     D  sdstat       E DS                  extname(SDSTAT)
031600210720     Dren@mode       E                     extfld(MODE)
031700210720      ** SDSTAT for system prefix
031800210720     D/COPY WNCPYSRC,MS6110MD02
031900210720      *
032000210720     D                 DS
032100210720     D  q@dqm                  1  12050
032200210720     D  q@sndref               1     50
032300210720     D  q@msgbuf              51  12050
032400210720      ** Data queue entry (message)
032500210720      *
032600210720     D                 DS
032700210720     D  q@dqc                  1     50
032800210720     D  q@prompt               1     50
032900210720      ** Data queue entry (control)
033000210720      *
033100210720      /SPACE 2
033200210720      *
033300210720     D                 DS
033400210720     Dp@msgbuf         S          12000
033500210720      ** API string parameters
033600210720     D/COPY WNCPYSRC,MS6110MD03
033700210720      *
033800210720     D APHEAD        E DS                  EXTNAME(APHEADPD)
033900210720      ** Incoming message header format
034000210720      *
034100210720     D APMH17        E DS                  EXTNAME(APMH17PD)                    CSW025
034200210720     D/COPY WNCPYSRC,MS6110MD04
034300210720      ** Meridian 1.7 header format                                             CSW025
034400210720                                                                                CSW025
034500210720     D                 DS
034600210720     D  w@tx3                  1      4    inz('}{4:')
034700210720     D  w@cr                   5      5    inz(x'0d')
034800210720     D  w@lf                   6      6    inz(x'25')
034900210720     D  w@crlf                 5      6
035000210720     D  w@stag                 7      9                                                       125554
035100210720     D  w@scan                 5      9                                                       125554
035200210720     D  w@cr2                 10     10    inz(x'0d')                           CSW038
035300210720     D  w@altlf               11     11    inz(x'15')                           CSW038
035400210720     D  w@altcrlf             10     11                                         CSW038
035500210720     D  txt3                   1      6
035600210720     Dw@null           S              1    inz(x'00')
035700210720     Dw@dly            S             14    inz('DLYJOB DLY(10)')
035800210720      ** Control codes and fixed texts
035900210720      *
036000210720                                                                                              CSW209
036100210720     Dcsw209           S              1    inz('N')                                           CSW209
036200210720      ** CSW209 switch                                                                        CSW209
036300210720                                                                                              CSW209
036400210720     Dw@c1             S              5  0 inz(*zero)                                         CSW209
036500210720     Dw@c2             S              5  0 inz(*zero)                                         CSW209
036600210720     Dw@c3             S              5  0 inz(*zero)                                         CSW209
036700210720     Dw@chr            S              1    inz(*blank)                                        CSW209
036800210720     Dz                S              2  0 inz(*zero)                                         CSW209
036900210720     Dw@f1             S          12000    inz(*blank)                                        CSW209
037000210720     Dw@f2             S          12000    inz(*blank)                                        CSW209
037100210720     Dw@f3             S          12000    inz(*blank)                                        CSW209
037200210720     Dw@f4             S          12000    inz(*blank)                                        CSW209
037300210720      ** Work field for the processing of Escape Translation                                  CSW209
037400210720     D digits          C                   '0123456789'                                       CSW212
037500210720
037600210720      **  Declare MQI structures needed
037700210720      * MQI Constants
037800210720     D***/COPY*QMQM/QRPGLESRC,CMQR                                                          MD041126
037900210720     D/COPY QMQM/QRPGLESRC,CMQG                                                             MD041126
038000210720
038100210720      ** Object Descriptor
038200210720     D MQOD            DS
038300210720     D***/COPY*QMQM/QRPGLESRC,CMQODR                                                        MD041126
038400210720     D/COPY QMQM/QRPGLESRC,CMQODG                                                           MD041126
038500210720
038600210720      ** Message Descriptor
038700210720     D MQMD            DS
038800210720     D***/COPY*QMQM/QRPGLESRC,CMQMDR                                                        MD041126
038900210720     D/COPY QMQM/QRPGLESRC,CMQMDG                                                           MD041126
039000210720
039100210720      ** Get message options
039200210720     D MQGMO           DS
039300210720     D***/COPY*QMQM/QRPGLESRC,CMQGMOR                                                       MD041126
039400210720     D/COPY QMQM/QRPGLESRC,CMQGMOG                                                          MD041126
039500210720
039600210720      ** Put message options
039700210720     D MQPMO           DS
039800210720     D***/COPY*QMQM/QRPGLESRC,CMQPMOR                                                       MD041126
039900210720     D/COPY QMQM/QRPGLESRC,CMQPMOG                                                          MD041126
040000210720
040100210720
040200210720      ** The include below brings in the return code structure that
040300210720      ** is used in calls to OS/400 APIs.
040400210720     D/COPY QSYSINC/QRPGLESRC,QUSEC
040500210720      * API Error code parameter
040600210720
040700210720      ** --- Start of fields used by access programs -------------------------- CSW025
040800210720     D @RtCd           S              7A                                        CSW025
040900210720      ** Return code                                                            CSW025
041000210720     D @Optn           S              7A                                        CSW025
041100210720      ** Option                                                                 CSW025
041200210720     D @SARD           S              6A                                        CSW025
041300210720      ** Switchable feature ID (for AOSARDR0)                                   CSW025
041400210720     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CSW025
041500210720      ** External DS for SAR details                                            CSW025
041600210720      ** --- End of fields used by access programs ---------------------------- CSW025
041700210720                                                                                CSW025
041800210720     D                 DS                                                       CSW025
041900210720     D BJRDNB5S                       5S 0                                      CSW025
042000210720     D BJRDNB5A                       5A   OVERLAY(BJRDNB5S)                    CSW025
042100210720     D BJDNWD5S                       5S 0                                      CSW025
042200210720     D BJDNWD5A                       5A   OVERLAY(BJDNWD5S)                    CSW025
042300210720                                                                                CSW025
042400210720     D DSTimeStamp     DS                                                                   MD051624
042500210720     D  DSYYYY                 1      4                                                     MD051624
042600210720     D  DSMM                   6      7                                                     MD051624
042700210720     D  DSDD                   9     10                                                     MD051624
042800210720     D  DSHH                  12     13                                                     MD051624
042900210720     D  DSMN                  15     16                                                     MD051624
043000210720     D  DSSC                  18     19                                                     MD051624
043100210720     D  DSMS                  21     26                                                     MD051624
043200210720      ** Declared variables for enhancement CTI004                                            CTI004
043300210720                                                                                              CTI004
043400210720     D PMSGBUF         S           9999                                                       CTI004
043500210720     D PMTPY           S              3                                                       CTI004
043600210720     D POKFLG          S              1                                                       CTI004
043700210720     D CTI004          S              1                                                       CTI004
043800210720     D PRTCD           S              7                                                       CTI004
043900210720     D POPTN           S              7                                                       CTI004
044000210720     D PSARD           S              6                                                       CTI004
044100210720     D PSysVal01       S             20A                                                      245310
044200210720     D PCurSet01       S            200A                                                      245310
044300210720     D PSysVal02       S             20A                                                      245310
044400210720     D PCurSet02       S            200A                                                      245310
044500210720     D PSysVal03       S             20A                                                      245310
044600210720     D PCurSet03       S            200A                                                      245310
044700210720     D PSysVal04       S             20A                                                      245310
044800210720     D PCurSet04       S            200A                                                      245310
044900210720     D PSysVal05       S             20A                                                      245310
045000210720     D PCurSet05       S            200A                                                      245310
045100210720     D PSysVal06       S             20A                                                      245310
045200210720     D PCurSet06       S            200A                                                      245310
045300210720     D PSysVal07       S             20A                                                      245310
045400210720     D PCurSet07       S            200A                                                      245310
045500210720     D PSysVal08       S             20A                                                      245310
045600210720     D PCurSet08       S            200A                                                      245310
045700210720     D PSysVal09       S             20A                                                      245310
045800210720     D PCurSet09       S            200A                                                      245310
045900210720     D PSysVal10       S             20A                                                      245310
046000210720     D PCurSet10       S            200A                                                      245310
046100210720                                                                                              CTI004
046200210720      ** Declared variable for system value setting                                         MD048231
046300210720     D MMMPaper        S              1A                                                    MD048231
046400210720      *                                                                                     MD051624
046500210720     D WMACFLAG        S              1                                                     MD051624
046600210720     D WLATM           S              6                                                     MD051624
046700210720     D PTimeStamp      S               Z                                                    MD051624
046800210720     D PDateIn         S              8                                                     MD051624
046900210720     D PMDNO           S              5P 0                                                  MD051624
047000210720     D PDATE6          S              6  0                                                  MD051624
047100210720     D PDATE7          S              7                                                     MD051624
047200210720                                                                                            MD041126
047300210720      ** MQ Parameters                                                                      MD041126
047400210720     D HCONN           S             10I 0                                                  MD041126
047500210720     D HIN             S             10I 0                                                  MD041126
047600210720     D HANDLE          S             10I 0                                                  MD041126
047700210720     D P@MsgLen        S             10I 0                                                  MD041126
047800210720     D CCODE           S             10I 0                                                  MD041126
047900210720     D OCODE           S             10I 0                                                  MD041126
048000210720     D REASON          S             10I 0                                                  MD041126
048100210720     D MESLEN          S             10I 0                                                  MD041126
048200210720     D OPTS            S             10I 0                                                  MD041126
048300210720     D QMNAME          S             48A                                                    MD041126
048400210720                                                                                            MD041126
048500210720      /EJECT
048600210720      *****************************************************************
048700210720      *  Index to Subroutines                                         *
048800210720      *                                                               *
048900210720      *  sr_init       : Initialise program                           *
049000210720      *  sr_trace      : Trace                                        *
049100210720      *  sr_in         : Get incoming messages and write to database  *
049200210720      *  sr_esctr      : Process Escape Sequence Translations         *                       CSW209
049300210720      *  sr_out        : Format and transmit outgoing messages        *
049400210720      *  sr_DQin       : Get incoming Data Queue msgs and write to d/b*         CSW025
049500210720      *  sr_DQout      : Format and transmit outgoing Data Queue msgs *         CSW025
049600210720      *  sr_DQeod      : Send EOD message to Data Queue               *         CSW025
049700210720      *  sr_msg        : Write incoming message to database           *
049800210720      *  sr_ix         : Generate index (reference) record            *
049900210720      *  sr_typa       : Process incoming messages of type A          *
050000210720      *  sr_typb       : Process incoming messages of type B          *
050100210720      *  sr_typc       : Process incoming messages of type C          *
050200210720      *  sr_typd       : Process incoming messages of type D          *
050300210720      *  sr_rpt        : Process report (ACK / NAK)                   *
050400210720      *  sr_trash      : Process unexpected data                      *
050500210720      *  sr_term       : Program termination                          *
050600210720      *  sr_open       : Open MQ series queue                         *
050700210720      *  sr_close      : Close MQ series queue                        *
050800210720      *  *PSSR         : Standard program exception error routine     *
050900210720      *****************************************************************
051000210720      /EJECT
051100210720      *
051200210720      ** Set up copyright parameter
051300210720     C                   movea     cpy@          cpy2@            80
051400210720      *
051500210720     C     *entry        plist
051600210720     C                   parm                    p@mcid           26
051700210720     C                   parm                    p@dtqm           10
051800210720     C                   parm                    p@dtqc           10
051900210720     C                   parm                    p@io              1
052000210720     C                   parm                    p@eod             4            CSW025
052100210720      *
052200210720      ** Push routine
052300210720     C                   z-add     1             Q
052400210720     C                   movel     'mainline'    @STK(Q)
052500210720      *
052600210720      ** Perform initial process
052700210720     C                   exsr      sr_init
052800210720      *
052900210720      *******************                                                       CSW025
053000210720      ***If*MQ*series*queue opened successfully...                              CSW025
053100210720     C*****w@open********ifeq      'Y'                                          CSW025
053200210720                                                                                CSW025
053300210720     C                   if         CSW025 = 'Y'                                CSW025
053400210720     C                                AND CSW038 = 'N'                          CSW038
053500210720      * If export is via Data Queues                                            CSW025
053600210720                                                                                CSW025
053700210720      ** execute process for incoming or outgoing messages                      CSW025
053800210720     C     p@io          ifeq      'I'                                          CSW025
053900210720     C                   exsr      sr_DQin                                      CSW025
054000210720     C                   else                                                   CSW025
054100210720     C                   exsr      sr_DQout                                     CSW025
054200210720     C                   endif                                                  CSW025
054300210720                                                                                CSW025
054400210720     C                   else                                                   CSW025
054500210720      * export is via MQSeries                                                  CSW025
054600210720                                                                                CSW025
054700210720      ** If no error on opening MQSeries queue                                  CSW025
054800210720     C                   if         w@MQOpenErr = 'N'                           CSW025
054900210720     C                              AND w@MQConnErr = 'N'                                     245310
055000210720      *
055100210720      ** execute process for incoming or outgoing messages
055200210720     C     p@io          ifeq      'I'
055300210720     C                   exsr      sr_in
055400210720     C                   else
055500210720     C                   exsr      sr_out
055600210720     C                   endif
055700210720                                                                                CSW025
055800210720     C                   endif                                                  CSW025
055900210720      *
056000210720     C                   endif
056100210720      *
056200210720      ** Program termination
056300210720      *
056400210720     C                   exsr      sr_term
056500210720      *
056600210720     C                   seton                                        LR
056700210720      /EJECT
056800210720      **********************************************************************
056900210720      * sr_trace       : Trace (if requested by user).                     *
057000210720      * --------                                                           *
057100210720      *                                                                    *
057200210720      * Called by      : sr_init, sr_in, sr_out, sr_term                   *
057300210720      *                                                                    *
057400210720      * Calls          : -                                                 *
057500210720      *                                                                    *
057600210720      **********************************************************************
057700210720      *
057800210720     C     sr_trace      begsr
057900210720      *
058000210720      ** Push subroutine
058100210720     C                   add       1             Q
058200210720     C                   movel     'sr_trace  '  @STK(Q)
058300210720      *
058400210720      ** Check whether trace requested. If it is, write trace information
058500210720      ** to report.
058600210720     C                   in        msstat
058700210720     C     TRACF         ifeq      'T'
058800210720      *
058900210720      ** If spool file not already open, open it now.
059000210720     C     w@prtopn      ifne      'Y'
059100210720     C                   movel     'Y'           w@prtopn          1
059200210720     C                   open      ms6110au
059300210720     C                   write     ms6110f1
059400210720     C                   endif
059500210720      *
059600210720      ** Check for overflow and rewrite headings if necessary.
059700210720     C     *in66         ifeq      *on
059800210720     C                   movel     *off          *in66
059900210720     C                   write     ms6110f1
060000210720     C                   endif
060100210720      *
060200210720      ** Set up standard details and write to report
060300210720     C                   time                    PR@TI
060400210720     C     REASON        ifne      0
060500210720     C                   movel(p)  REASON        PR@RC
060600210720     C                   else
060700210720     C                   clear                   PR@RC
060800210720     C                   endif
060900210720     C                   write     ms6110t1
061000210720      *
061100210720      ** If data in buffer, write this too
061200210720     C     t@tdat        ifne      *blank
061300210720     C                   movel(p)  t@tdat        PR@DT
061400210720     C                   write     ms6110t2
061500210720     C                   clear                   t@tdat          100
061600210720     C                   endif
061700210720      *
061800210720     C                   endif
061900210720      *
062000210720      ** Pop subroutine
062100210720     C                   clear                   @STK(Q)
062200210720     C                   sub       1             Q
062300210720     C                   endsr
062400210720      /EJECT
062500210720      **********************************************************************
062600210720      * sr_out         : Format and transmit outgoing messages             *
062700210720      * ------                                                             *
062800210720      *                                                                    *
062900210720      * Called by      : Mainline                                          *
063000210720      *                                                                    *
063100210720      * Calls          : QMQM                                              *
063200210720      *                                                                    *
063300210720      **********************************************************************
063400210720      *
063500210720     C     sr_out        begsr
063600210720      *
063700210720      ** Push subroutine
063800210720     C                   add       1             Q
063900210720     C                   movel     'sr_out'      @STK(Q)
064000210720      *
064100210720      ** Prompt server for first message (if recovery required request
064200210720      ** failed message first).
064300210720     C     MCRECO        ifeq      'Y'
064400210720     C                   movel(p)  MCRSTR        q@prompt
064500210720     C                   else
064600210720     C                   movel(p)  '*NEXT'       q@prompt
064700210720     C                   endif
064800210720     C                   call      'QSNDDTAQ'    q@snddtaq
064900210720      *
065000210720      ** DoUntil termination requested or an abormal condition detected
065100210720     C     *in01         doueq     *on
065200210720     C     w@abnormal    oreq      'Y'
065300210720      *
065400210720      ** Check for termination request
065500210720     C                   shtdn                                        01
065600210720      *
065700210720      ** If termination not requested prompt server to prepare next message
065800210720      ** while we process the current one
065900210720     C     *in01         ifeq      *off
066000210720     C                   movel(p)  '*NEXT'       q@prompt
066100210720     C                   call      'QSNDDTAQ'    q@snddtaq
066200210720     C                   endif
066300210720      *
066400210720      ** Pick up current message from data queue
066500210720     C                   call      'QRCVDTAQ'    q@rcvdtaq
066600210720      *
066700210720      ** If message available attempt to send it
066800210720     C     q@sndref      ifne      '*NONE'
066900210720     C     q@sndref      andne     '*ERROR'
067000210720      *
067100210720      ** Access PENDing message on file to lock
067200210720     C                   movel     mgde          smgde             6 0                        CSW034
067300210720     C                   movel     q@sndref      w@trn            16
067400210720     C     w@trn         chain     mgorefl0                           50
067500210720
067600210720      ** Set dataq priority key                                                              BUG3189
067700210720     C     mtpy          ifeq      '940'                                                     BUG3189
067800210720     C     mtpy          oreq      '950'                                                     BUG3189
067900210720     C                   move      '90'          q@skey                                      BUG3189
068000210720     C                   else                                                                BUG3189
068100210720     C                   move      '10'          q@skey                                      BUG3189
068200210720     C                   end                                                                 BUG3189
068300210720     C                   movel(p)  q@skey        MDCID
068400210720      *
068500210720      ** Set up message details
068600210720      ** (API header format plus message sent from compression program)
068700210720     C/COPY WNCPYSRC,MS6110MC01
068800210720     C     NWRK          ifeq      'PAPER'                                                    251373
068900210720     C     MMMPaper      ANDNE     'Y'                                                      MD048231
069000210720     C                   GOTO      DISCRD                                                     251373
069100210720     C                   endif                                                                251373
069200210720     C     NWRK          ifeq      'MINT'
069300210720     C                   movel(p)  'MIDAS_MINT'  APTGTTYPE
069400210720     C                   else
069500210720     C                   movel(p)  'MIDAS_SWIFT' APTGTTYPE
069600210720     C                   endif
069700210720     C                   EVAL      p@msgbuf = APHEAD + q@msgbuf
069800210720     C/COPY WNCPYSRC,MS6110MC02
069900210720
070000210720      ** If we are sending messages to MMM via MQSeries then we have to                       CSW038
070100210720      ** set the Meridian 1.7 header fields                                                   CSW038
070200210720     C                   if        CSW038 = 'Y'                                               CSW038
070300210720     C                   eval      RAMSGTYPE = 'Midas_SWIFT'                                  CSW038
070400210720     C                   eval      RATGTSYS  = 'Midas'                                        CSW038
070500210720     C                   EVAL      p@msgbuf = APMH17 + q@msgbuf                               CSW038
070600210720     C                   else                                                                 CSW038
070700210720     C                   EVAL      p@msgbuf = APHEAD + q@msgbuf                               CSW038
070800210720     C                   endif                                                                CSW038
070900210720
071000210720      ** Get message length
071100210720
071200210720     C     w@null        scan      p@msgbuf      p@msglen                 99    *
071300210720     C     *in99         ifeq      *off
071400210720     C                   z-add     12000         p@msglen
071500210720     c                   endif
071600210720
071700210720      ** Remove null byte
071800210720
071900210720     C     w@null:' '    xlate     p@msgbuf      p@msgbuf
072000210720
072100210720      ** MDFMT (Format Name) is a subfield of the MQMD data structure,
072200210720      ** defined in the include member CMQMDR.
072300210720      ** FMSTR is a named constant defined in CMQR; it contains 'MQSTR   '.
072400210720     C                   EVAL      MDFMT = FMSTR
072500210720     C/COPY WNCPYSRC,MS6110MC03
072600210720
072700210720      ** Send message
072800210720     C**********         Z-ADD     MQPUT         CID                                        MD041126
072900210720     C**********         CALL      'QMQM'                                                   MD041126
073000210720     C**********         PARM                    CID               9 0                      MD041126
073100210720     C**********         PARM                    HCONN             9 0                      MD041126
073200210720     C**********         PARM                    HIN               9 0                      MD041126
073300210720     C**********         PARM                    MQMD                                       MD041126
073400210720     C**********         PARM                    MQPMO                                      MD041126
073500210720     C**********         PARM                    p@msglen          9 0                      MD041126
073600210720     C**********         PARM                    p@msgbuf                                   MD041126
073700210720     C**********         PARM                    CCODE             9 0                      MD041126
073800210720     C**********         PARM                    REASON            9 0                      MD041126
073900210720                                                                                            MD041126
073901210720     C                   Z-ADD     PMNMID        PMOPT                                      MD058137
074000210720     C                   CALLP     MQPUT( HCONN : HIN : MQMD : MQPMO :                      MD041126
074100210720     C                                    P@MsgLen : %ADDR(P@MsgBuf) :                      MD041126
074200210720     C                                    CCODE : REASON )                                  MD041126
074300210720      *
074400210720      ** Trace
074500210720     C                   movel     '*PUT   '     PR@FN
074600210720     C                   movel     q@msgbuf      t@tdat
074700210720     C                   exsr      sr_trace
074800210720
074900210720      ** If send message failed, indicate abnormal end
075000210720
075100210720     C                   IF        REASON <> RCNONE
075200210720
075300210720      ** Log recovery details
075400210720
075500210720     C     p@mcid        chain     MSMCIDL0                           51
075600210720     C     *in51         ifeq      *off
075700210720     C                   movel(p)  TRNO          MCRSTR
075800210720     C                   movel     'Y'           MCRECO
075900210720     C                   update    MSMCIDD0
076000210720     C                   endif
076100210720      *
076200210720     C                   movel     'Y'           w@abnormal
076300210720     C                   movel     'QMQM     '   w0file
076400210720     C                   movel     'MEM6001'     w0msgd
076500210720     C                   movel     'MIDAS  '     w0msgf
076600210720     C                   movel     'Send message'w0key
076700210720     C                   movel     REASON        w0reas
076800210720     C                   z-add     101           w0ernb
076900210720
077000210720      ** If no failure
077100210720
077200210720     C                   else
077300210720      *
077400210720      ** If this was recovery run, recovery was a success so reset
077500210720      ** details
077600210720     C     MCRECO        ifeq      'Y'
077700210720     C     p@mcid        chain     MSMCIDl0                           50
077800210720     C     *in50         ifeq      *off
077900210720     C                   clear                   MCRSTR
078000210720     C                   movel     'N'           MCRECO
078100210720     C                   update    MSMCIDD0
078200210720     C                   endif
078300210720     C                   endif
078400210720      *
078500210720     C                   endif
078600210720      *
078700210720      ** Update message status: RECO -> failed on this attempt
078800210720      ** (set for recovery); TRAN -> Transmitted OK.
078900210720      *                                                                                       251373
079000210720     C     DISCRD        TAG                                                                  251373
079100210720      *                                                                                       251373
079200210720     C     w@abnormal    ifeq      'Y'
079300210720     C                   movel     'RECO'        MGST
079400210720     C                   movel     'Y'           MPDE                                         134491
079500210720     C                   else
079600210720     C                   movel     '3'           MGSG
079700210720     C                   movel     'TRAN'        MGST
079800210720     C                   endif
079900210720      *                                                                                     MD051624
080000210720      ** If 'MachineDateforTRAN' system value is ON, get machine time                       MD051624
080100210720      *                                                                                     MD051624
080200210720     C                   IF        WMACFLAG = 'Y'                                           MD051624
080300210720     C                   CALLB     'ZAGENTMSTM'                                             MD051624
080400210720     C                   PARM                    PTimeStamp                                 MD051624
080500210720     C                   MOVE      PTimeStamp    DSTimeStamp                                MD051624
080600210720      *                                                                                     MD051624
080700210720      ** Convert from YYYYY to 99999                                                        MD051624
080800210720      *                                                                                     MD051624
080900210720     C                   EVAL      PDATEIN = DSYYYY + DSMM + DSDD                           MD051624
081000210720     C                   CALLB     'ZDATE10'                                                MD051624
081100210720     C                   PARM                    PDateIN                                    MD051624
081200210720     C                   PARM                    PMDNO                                      MD051624
081300210720      *                                                                                     MD051624
081400210720      ** Convert from 99999 to DDMMMYY                                                      MD051624
081500210720      *                                                                                     MD051624
081600210720     C                   CALL      'ZDATE2'                                                 MD051624
081700210720     C                   PARM                    PMDNO                                      MD051624
081800210720     C                   PARM                    BJDFIN                                     MD051624
081900210720     C                   PARM      *ZERO         PDATE6                                     MD051624
082000210720     C                   PARM      *BLANKS       PDATE7                                     MD051624
082100210720     C                   MOVEL     PDATE7        LADT                                       MD051624
082200210720      *                                                                                     MD051624
082300210720      ** Move DS time to numeric                                                            MD051624
082400210720      *                                                                                     MD051624
082500210720     C                   EVAL      WLATM = DSHH + DSMN + DSSC                               MD051624
082600210720     C                   MOVE      WLATM         LATM                                       MD051624
082700210720     C                   ELSE                                                               MD051624
082800210720     C                   movel     BJMRDT        LADT
082900210720     C                   TIME                    LATM
083000210720     C                   ENDIF                                                              MD051624
083100210720     C                   update    mgorefd0
083200210720     C                   commit
083300210720      *
083400210720      ** else (if no messages to send) wait for prompt/time-out
083500210720     C                   else
083600210720                                                                                CSW038
083700210720      * If Midas EoD processing is requested, the first time we get             CSW038
083800210720      * here all messages must have been sent so send the RunDate               CSW038
083900210720      * Synchronisation message just once.                                      CSW038
084000210720     C                   if        p@eod = '*EOD'                               CSW038
084100210720     C                   exsr      sr_eod                                       CSW038
084200210720     C                   eval      p@eod = ' '                                  CSW038
084300210720     C                   endif                                                  CSW038
084400210720                                                                                CSW038
084500210720     C                   callb     'MSC8011M'
084600210720     C                   endif
084700210720     C                   enddo
084800210720      *
084900210720      ** Pop subroutine
085000210720     C                   clear                   @STK(Q)
085100210720     C                   sub       1             Q
085200210720     C                   endsr
085300210720      /EJECT
085400210720      **********************************************************************                  CSW038
085500210720      * sr_eod         : Send EOD message to MQ   Queue                    *                  CSW038
085600210720      * ------                                                             *                  CSW038
085700210720      *                                                                    *                  CSW038
085800210720      * Called by      : Mainline                                          *                  CSW038
085900210720      *                                                                    *                  CSW038
086000210720      * Calls          :                                                   *                  CSW038
086100210720      *                                                                    *                  CSW038
086200210720      **********************************************************************                  CSW038
086300210720      *                                                                                       CSW038
086400210720     C     sr_eod        begsr                                                                CSW038
086500210720      *                                                                                       CSW038
086600210720      ** Push subroutine                                                                      CSW038
086700210720     C                   add       1             Q                                            CSW038
086800210720     C                   movel     'sr_eod'      @STK(Q)                                      CSW038
086900210720                                                                                              CSW038
087000210720      ** Message consists of                                                                  CSW038
087100210720      ** - Meridian 1.7 header                                                                CSW038
087200210720      ** - Specific EOD text                                                                  CSW038
087300210720      **         - Rundate and DateOfNextWorkingDay in 5A format                              CSW038
087400210720                                                                                              CSW038
087500210720      ** Set the Meridian 1.7 header fields                                                   CSW038
087600210720     C                   eval      RAMSGTYPE = 'Rundate_Synch'                                CSW038
087700210720     C                   eval      RATGTSYS  = 'Midas'                                        CSW038
087800210720                                                                                              CSW038
087900210720      ** Convert Rundate & DNWD from 3P to 5A                                                 CSW038
088000210720     C                   z-add     BJRDNB        BJRDNB5S                                     CSW038
088100210720     C                   z-add     BJDNWD        BJDNWD5S                                     CSW038
088200210720                                                                                              CSW038
088300210720     C                   EVAL      p@msgbuf = APMH17 + BJRDNB5A + BJDNWD5A +                  CSW038
088400210720     C                                        LIBR                                            CSW038
088500210720                                                                                              CSW038
088600210720      ** Send message                                                                         CSW038
088700210720      ** Get message length                                                                   CSW038
088800210720                                                                                              CSW038
088900210720     C     w@null        scan      p@msgbuf      p@msglen                 99    *             CSW038
089000210720     C     *in99         ifeq      *off                                                       CSW038
089100210720     C                   z-add     12000         p@msglen                                     CSW038
089200210720     c                   endif                                                                CSW038
089300210720                                                                                              CSW038
089400210720      ** Remove null byte                                                                     CSW038
089500210720                                                                                              CSW038
089600210720     C     w@null:' '    xlate     p@msgbuf      p@msgbuf                                     CSW038
089700210720                                                                                              CSW038
089800210720      ** MDFMT (Format Name) is a subfield of the MQMD data structure,                        CSW038
089900210720      ** defined in the include member CMQMDR.                                                CSW038
090000210720      ** FMSTR is a named constant defined in CMQR; it contains 'MQSTR   '.                   CSW038
090100210720     C                   EVAL      MDFMT = FMSTR                                              CSW038
090200210720                                                                                              CSW038
090300210720      ** Send message                                                                         CSW038
090400210720     C**********         Z-ADD     MQPUT         CID                                 CSW038 MD041126
090500210720     C**********         CALL      'QMQM'                                            CSW038 MD041126
090600210720     C**********         PARM                    CID               9 0               CSW038 MD041126
090700210720     C**********         PARM                    HCONN             9 0               CSW038 MD041126
090800210720     C**********         PARM                    HIN               9 0               CSW038 MD041126
090900210720     C**********         PARM                    MQMD                                CSW038 MD041126
091000210720     C**********         PARM                    MQPMO                               CSW038 MD041126
091100210720     C**********         PARM                    p@msglen          9 0               CSW038 MD041126
091200210720     C**********         PARM                    p@msgbuf                            CSW038 MD041126
091300210720     C**********         PARM                    CCODE             9 0               CSW038 MD041126
091400210720     C**********         PARM                    REASON            9 0               CSW038 MD041126
091500210720                                                                                            MD041126
091600210720     C                   CALLP     MQPUT( HCONN : HIN : MQMD : MQPMO :                      MD041126
091700210720     C                                    P@MsgLen : %ADDR(P@MsgBuf) :                      MD041126
091800210720     C                                    CCODE : REASON )                                  MD041126
091900210720      *                                                                                       CSW038
092000210720      ** Trace                                                                                CSW038
092100210720     C                   movel     '*PUT   '     PR@FN                                        CSW038
092200210720     C                   movel     q@msgbuf      t@tdat                                       CSW038
092300210720     C                   exsr      sr_trace                                                   CSW038
092400210720                                                                                              CSW038
092500210720      ** If send message failed, indicate abnormal end                                        CSW038
092600210720                                                                                              CSW038
092700210720     C                   IF        REASON <> RCNONE                                           CSW038
092800210720                                                                                              CSW038
092900210720     C                   movel     'Y'           w@abnormal                                   CSW038
093000210720     C                   movel     'QMQM     '   w0file                                       CSW038
093100210720     C                   movel     'MEM6001'     w0msgd                                       CSW038
093200210720     C                   movel     'MIDAS  '     w0msgf                                       CSW038
093300210720     C                   movel     'Send EOD msg'w0key                                        CSW038
093400210720     C                   movel     REASON        w0reas                                       CSW038
093500210720     C                   z-add     204           w0ernb                                       CSW038
093600210720                                                                                              CSW038
093700210720                                                                                              CSW038
093800210720      ** Trace                                                                                CSW038
093900210720     C                   movel     '*PUT   '     PR@FN                                        CSW038
094000210720     C                   movel     p@msgbuf      t@tdat                                       CSW038
094100210720     C                   exsr      sr_trace                                                   CSW038
094200210720                                                                                              CSW038
094300210720     C                   else                                                                 CSW038
094400210720                                                                                              CSW038
094500210720      ** If send message succeeded, let Midas know processing can continue                    CSW038
094600210720     C     *lock         in        mestat                                                     CSW038
094700210720     C                   eval      MRDEOD = 'Y'                                               CSW038
094800210720     C                   out       mestat                                                     CSW038
094900210720                                                                                              CSW038
095000210720     C                   endif                                                                CSW038
095100210720                                                                                              CSW038
095200210720      ** Pop subroutine                                                                       CSW038
095300210720     C                   clear                   @STK(Q)                                      CSW038
095400210720     C                   sub       1             Q                                            CSW038
095500210720     C                   endsr                                                                CSW038
095600210720      /EJECT                                                                                  CSW038
095700210720      **********************************************************************    CSW025
095800210720      * sr_DQout       : Format and transmit outgoing msgs to a Data Queue *    CSW025
095900210720      * --------                                                           *    CSW025
096000210720      *                                                                    *    CSW025
096100210720      *                                                                    *    CSW025
096200210720      * Called by      : Mainline                                          *    CSW025
096300210720      *                                                                    *    CSW025
096400210720      * Calls          : QSNDDTAQ                                          *    CSW025
096500210720      *                : QRCVDTAQ                                          *    CSW025
096600210720      *                : MSC8011M                                          *    CSW025
096700210720      *                                                                    *    CSW025
096800210720      **********************************************************************    CSW025
096900210720      *                                                                         CSW025
097000210720     C     sr_DQout      begsr                                                  CSW025
097100210720      *                                                                         CSW025
097200210720      ** Push subroutine                                                        CSW025
097300210720     C                   add       1             Q                              CSW025
097400210720     C                   movel     'sr_DQout'    @STK(Q)                        CSW025
097500210720                                                                                CSW025
097600210720      ** Prompt server for first message                                        CSW025
097700210720     C                   movel(p)  '*NEXT'       q@prompt                       CSW025
097800210720     C                   call      'QSNDDTAQ'    q@snddtaq                      CSW025
097900210720                                                                                CSW025
098000210720      ** DoUntil termination requested or an abormal condition detected         CSW025
098100210720     C     *in01         doueq     *on                                          CSW025
098200210720     C     w@abnormal    oreq      'Y'                                          CSW025
098300210720                                                                                CSW025
098400210720      ** Check for termination request                                          CSW025
098500210720     C                   shtdn                                        01        CSW025
098600210720                                                                                CSW025
098700210720      ** If termination not requested prompt server to prepare next message     CSW025
098800210720      ** while we process the current one                                       CSW025
098900210720     C     *in01         ifeq      *off                                         CSW025
099000210720     C                   movel(p)  '*NEXT'       q@prompt                       CSW025
099100210720     C                   call      'QSNDDTAQ'    q@snddtaq                      CSW025
099200210720     C                   endif                                                  CSW025
099300210720                                                                                CSW025
099400210720      ** Pick up current message from data queue                                CSW025
099500210720     C                   call      'QRCVDTAQ'    q@rcvdtaq                      CSW025
099600210720                                                                                CSW025
099700210720      ** If message available attempt to send it                                CSW025
099800210720     C     q@sndref      ifne      '*NONE'                                      CSW025
099900210720     C     q@sndref      andne     '*ERROR'                                     CSW025
100000210720                                                                                CSW025
100100210720      ** Access PENDing message on file to lock                                 CSW025
100200210720     C                   movel     q@sndref      w@trn            16            CSW025
100300210720     C     w@trn         chain     mgorefl0                           50        CSW025
100400210720                                                                                CSW025
100500210720      ** Set dataq priority key                                                              BUG3189
100600210720     C     mtpy          ifeq      '940'                                                     BUG3189
100700210720     C     mtpy          oreq      '950'                                                     BUG3189
100800210720     C                   move      '90'          q@skey                                      BUG3189
100900210720     C                   else                                                                BUG3189
101000210720     C                   move      '10'          q@skey                                      BUG3189
101100210720     C                   end                                                                 BUG3189
101200210720      *                                                                                      BUG3189
101300210720      ** Validate if PAPER will be generated and system value should be Y                   MD048231
101400210720      ** to generate                                                                        MD048231
101500210720     C     NWRK          IFEQ      'PAPER'                                                  MD048231
101600210720     C     MMMPaper      ANDNE     'Y'                                                      MD048231
101700210720     C                   GOTO      DISCRDDQ                                                 MD048231
101800210720     C                   ENDIF                                                              MD048231
101900210720      **                                                                                    MD048231
102000210720      ** Message consists of                                                    CSW025
102100210720      ** - Meridian 1.7 header                                                  CSW025
102200210720      ** - message header = MGOREFPD data                                       CSW025
102300210720      ** - SWIFT II text                                                        CSW025
102400210720                                                                                CSW025
102500210720      ** Set the Meridian 1.7 header fields                                     CSW025
102600210720     C                   eval      RAMSGTYPE = 'Midas_SWIFT'                    CSW025
102700210720     C                   eval      RATGTSYS  = 'Midas'                          CSW025
102800210720                                                                                CSW025
102900210720      ** The message header and the SWIFT II text are formatted by the          CSW025
103000210720      ** compression program. They are received in q@msgbuf which is a          CSW025
103100210720      ** subfield of q@dqm.  This is a parameter in the q@rcvdtaq plist,        CSW025
103200210720      ** used on the call to QRCVDTAQ)                                          CSW025
103300210720     C                   EVAL      p@msgbuf = APMH17 + q@msgbuf                 CSW025
103400210720                                                                                CSW025
103500210720      ** Remove null byte                                                       CSW025
103600210720     C     w@null:' '    xlate     p@msgbuf      p@msgbuf                       CSW025
103700210720                                                                                CSW025
103800210720      ** Send message                                                           CSW025
103900210720     C                   eval      q@DQData = p@msgbuf                          CSW025
104000210720     C                   call      'QSNDDTAQ'    q@sndDQpl              99      CSW025
104100210720                                                                                CSW025
104200210720      ** Trace                                                                  CSW025
104300210720     C                   movel     '*PUT   '     PR@FN                          CSW025
104400210720     C                   movel     q@msgbuf      t@tdat                         CSW025
104500210720     C                   exsr      sr_trace                                     CSW025
104600210720                                                                                CSW025
104700210720      ** If send message failed, indicate abnormal end                          CSW025
104800210720     C                   if        *in99 = *on                                  CSW025
104900210720                                                                                CSW025
105000210720     C                   movel     'Y'           w@abnormal                     CSW025
105100210720     C                   movel     'DataQueue'   w0file                         CSW025
105200210720     C                   movel     'MEM6001'     w0msgd                         CSW025
105300210720     C                   movel     'MIDAS  '     w0msgf                         CSW025
105400210720     C                   movel     'Send message'w0key                          CSW025
105500210720     C                   movel     *blank        w0reas                         CSW025
105600210720     C                   z-add     201           w0ernb                         CSW025
105700210720                                                                                CSW025
105800210720     C                   endif                                                  CSW025
105900210720                                                                                CSW025
106000210720      ** Update message status                                                  CSW025
106100210720                                                                                CSW025
106200210720     C     DISCRDDQ      TAG                                                                MD048231
106300210720     C     w@abnormal    ifeq      'Y'                                          CSW025
106400210720      ** If error: to set on the PDE flag, in case the message was delivered    CSW025
106500210720     C                   movel     'Y'           MPDE                           CSW025
106600210720                                                                                CSW025
106700210720     C                   else                                                   CSW025
106800210720      ** If no error: to show as transmitted                                    CSW025
106900210720     C                   movel     '3'           MGSG                           CSW025
107000210720     C                   movel     'TRAN'        MGST                           CSW025
107100210720     C                   endif                                                  CSW025
107200210720                                                                                CSW025
107300210720     C                   movel     BJMRDT        LADT                           CSW025
107400210720     C                   TIME                    LATM                           CSW025
107500210720     C                   update    mgorefd0                                     CSW025
107600210720     C                   commit                                                 CSW025
107700210720                                                                                CSW025
107800210720      ** else (if no messages to send) wait for prompt/time-out                 CSW025
107900210720     C                   else                                                   CSW025
108000210720                                                                                CSW025
108100210720      * If Midas EoD processing is requested, the first time we get             CSW025
108200210720      * here all messages must have been sent so send the RunDate               CSW025
108300210720      * Synchronisation message just once.                                      CSW025
108400210720     C     CSW034        ifeq      'N'                                          CSW034
108500210720     C     mgde          orne      smgde                                        CSW034
108600210720     C                   if        p@eod = '*EOD'                               CSW025
108700210720     C                   exsr      sr_DQeod                                     CSW025
108800210720     C                   eval      p@eod = ' '                                  CSW025
108900210720     C                   endif                                                  CSW025
109000210720     C                   endif                                                  CSW034
109100210720                                                                                CSW025
109200210720     C                   callb     'MSC8011M'                                   CSW025
109300210720     C                   endif                                                  CSW025
109400210720     C                   enddo                                                  CSW025
109500210720                                                                                CSW025
109600210720      ** Pop subroutine                                                         CSW025
109700210720     C                   clear                   @STK(Q)                        CSW025
109800210720     C                   sub       1             Q                              CSW025
109900210720     C                   endsr                                                  CSW025
110000210720      /EJECT                                                                    CSW025
110100210720      **********************************************************************    CSW025
110200210720      * sr_DQeod       : Send EOD message to Data Queue                    *    CSW025
110300210720      * --------                                                           *    CSW025
110400210720      *                                                                    *    CSW025
110500210720      * Called by      : Mainline                                          *    CSW025
110600210720      *                                                                    *    CSW025
110700210720      * Calls          : QSNDDTAQ                                          *    CSW025
110800210720      *                                                                    *    CSW025
110900210720      **********************************************************************    CSW025
111000210720      *                                                                         CSW025
111100210720     C     sr_DQeod      begsr                                                  CSW025
111200210720      *                                                                         CSW025
111300210720      ** Push subroutine                                                        CSW025
111400210720     C                   add       1             Q                              CSW025
111500210720     C                   movel     'sr_DQeod'    @STK(Q)                        CSW025
111600210720                                                                                CSW025
111700210720      ** Message consists of                                                    CSW025
111800210720      ** - Meridian 1.7 header                                                  CSW025
111900210720      ** - Specific EOD text                                                    CSW025
112000210720      **         - Rundate and DateOfNextWorkingDay in 5A format                CSW025
112100210720                                                                                CSW025
112200210720      ** Set the Meridian 1.7 header fields                                     CSW025
112300210720     C                   eval      RAMSGTYPE = 'Rundate_Synch'                  CSW025
112400210720     C                   eval      RATGTSYS  = 'Midas'                          CSW025
112500210720                                                                                CSW025
112600210720      ** Convert Rundate & DNWD from 3P to 5A                                   CSW025
112700210720     C                   z-add     BJRDNB        BJRDNB5S                       CSW025
112800210720     C                   z-add     BJDNWD        BJDNWD5S                       CSW025
112900210720                                                                                CSW025
113000210720      ** Send the header, rundate, tommorows rundate and the system identifer                 220126
113100210720     C**********         EVAL      q@DQData = APMH17 + BJRDNB5A + BJDNWD5A             CSW025 220126
113200210720     C                   EVAL      q@DQData = APMH17 + BJRDNB5A + BJDNWD5A +                  220126
113300210720     C                                        LIBR                                            220126
113400210720                                                                                CSW025
113500210720      ** Send message                                                           CSW025
113600210720     C                   call      'QSNDDTAQ'    q@sndDQpl              99      CSW025
113700210720                                                                                CSW025
113800210720      ** Trace                                                                  CSW025
113900210720     C                   movel     '*PUT   '     PR@FN                          CSW025
114000210720     C                   movel     p@msgbuf      t@tdat                         CSW025
114100210720     C                   exsr      sr_trace                                     CSW025
114200210720                                                                                CSW025
114300210720      ** If send message failed, indicate abnormal end                          CSW025
114400210720     C                   if        *in99 = *on                                  CSW025
114500210720                                                                                CSW025
114600210720     C                   movel     'Y'           w@abnormal                     CSW025
114700210720     C                   movel     'DataQueue'   w0file                         CSW025
114800210720     C                   movel     'MEM6001'     w0msgd                         CSW025
114900210720     C                   movel     'MIDAS  '     w0msgf                         CSW025
115000210720     C                   movel     'Send EOD msg'w0key                          CSW025
115100210720     C                   movel     *blank        w0reas                         CSW025
115200210720     C                   z-add     203           w0ernb                         CSW025
115300210720                                                                                CSW025
115400210720     C                   else                                                   CSW025
115500210720                                                                                CSW025
115600210720      ** If send message succeeded, let Midas know processing can continue      CSW025
115700210720     C     *lock         in        mestat                                       CSW025
115800210720     C                   eval      MRDEOD = 'Y'                                 CSW025
115900210720     C                   out       mestat                                       CSW025
116000210720                                                                                CSW025
116100210720     C                   endif                                                  CSW025
116200210720                                                                                CSW025
116300210720      ** Pop subroutine                                                         CSW025
116400210720     C                   clear                   @STK(Q)                        CSW025
116500210720     C                   sub       1             Q                              CSW025
116600210720     C                   endsr                                                  CSW025
116700210720      /EJECT
116800210720      **********************************************************************
116900210720      * sr_in          : Get incoming messages and write to database       *
117000210720      * -----                                                              *
117100210720      *                                                                    *
117200210720      * Called by      : Mainline                                          *
117300210720      *                                                                    *
117400210720      * Calls            QMQM                                              *
117500210720      *                  sr_msg                                            *
117600210720      *                  sr_rpt                                            *
117700210720      *                  sr_trash                                          *
117800210720      *                  sr_esctr                                          *                  CSW209
117900210720      *                                                                    *
118000210720      **********************************************************************
118100210720      *
118200210720     C     sr_in         begsr
118300210720      *
118400210720      ** Push subroutine
118500210720     C                   add       1             Q
118600210720     C                   movel     'sr_in'       @STK(Q)
118700210720      *
118800210720      ** Access incoming data until termination requested by user,
118900210720      ** or API error.
119000210720      *
119100210720     C     *in01         doueq     *on
119200210720     C     REASON        orne      RCNONE
119300210720     C     REASON        andne     RC2033
119400210720
119500210720      ** Get options: WAIT, CONVERT and ALLOW TRUNCATION.
119600210720      ** Note: the last of these options means that a message longer than
119700210720      ** the buffer length defined in this module (currently 1500 bytes)
119800210720      ** will be read and removed from the queue.  Any data in the message
119900210720      ** after the 1500th byte will be lost.
120000210720     C                   Z-ADD     GMWT          GMOPT
120100210720     C                   ADD       GMCONV        GMOPT
120200210720     C                   ADD       GMATM         GMOPT
120300210720
120400210720      ** Set wait interval to 20 seconds
120500210720     C                   Z-ADD     20000         GMWI
120600210720
120700210720      ** Perform get operation inside commitment control. Commitment
120800210720      ** boundary is after the message management file updates.
120900210720     C                   ADD       GMSYP         GMOPT
121000210720
121100210720      ** MsgId and CorrelId are selectors cleared to ensure messages
121200210720      ** are processed in arrival/priority sequence
121300210720     C                   MOVEL     MINONE        MDMID
121400210720     C**********         MOVEL     MCSYTM        MDCID                               CSW039 BUG14494
121500210720     C**********         MOVEL     CINONE        MDCID                               BUG14494 257554
121600210720     C**********         MOVEL     MCSYTM        MDCID                               257554 AR214111
121700210720     C*****              MOVEL     CINONE        MDCID                                        CSW039
121800210720
121900210720      ** Clear message buffer
122000210720     C                   clear                   q@msgbuf
122100210720
122200210720      ** Get message
122300210720     C**********         Z-ADD     MQGET         CID                                        MD041126
122400210720     C**********         CALL      'QMQM'                                                   MD041126
122500210720     C**********         PARM                    CID               9 0                      MD041126
122600210720     C**********         PARM                    HCONN             9 0                      MD041126
122700210720     C**********         PARM                    HIN               9 0                      MD041126
122800210720     C**********         PARM                    MQMD                                       MD041126
122900210720     C**********         PARM                    MQGMO                                      MD041126
123000210720     C**********         PARM      12000         p@msglen          9 0                      MD041126
123100210720     C**********         PARM                    q@msgbuf                                   MD041126
123200210720     C**********         PARM                    MESLEN            9 0                      MD041126
123300210720     C**********         PARM                    CCODE             9 0                      MD041126
123400210720     C**********         PARM                    REASON            9 0                      MD041126
123500210720                                                                                            MD041126
123600210720     C                   Z-ADD     12000         P@MsgLen                                   MD041126
123700210720     C                   CALLP     MQGET( HCONN : HIN : MQMD : MQGMO :                      MD041126
123800210720     C                                    P@MsgLen : %ADDR(Q@MsgBuf) :                      MD041126
123900210720     C                                    MESLEN : CCODE : REASON )                         MD041126
124000210720
124100210720      ** Message starts after the API header block
124200210720
124300210720     C                   clear                   p@msgbuf
124400210720     C**********         subst     q@msgbuf:HLEN p@msgbuf                                   BUG13405
124500210720     C                   Movel     q@msgbuf      p@msgbuf                                   BUG13405
124600210720      *
124700210720      ** Trace
124800210720     C                   movel     '*GET   '     PR@FN
124900210720     C                   movel     p@msgbuf      t@tdat
125000210720     C                   exsr      sr_trace
125100210720      *
125200210720      ** If receive message failed, indicate abnormal end
125300210720      *
125400210720     C     REASON        ifne      RCNONE
125500210720     C     REASON        andne     RC2033
125600210720     C                   movel     'Y'           w@abnormal
125700210720     C                   movel     'QMQM     '   w0file
125800210720     C                   movel     'MEM6001'     w0msgd
125900210720     C                   movel     'MIDAS  '     w0msgf
126000210720     C                   movel     'Rcv message' w0key
126100210720     C                   movel     REASON        w0reas
126200210720     C                   z-add     102           w0ernb
126300210720     C                   else
126400210720
126500210720      ** Else, if data received and no error
126600210720
126700210720     C     REASON        ifne      RC2033
126800210720      *                                                                                       CSW209
126900210720      ** Scan message for Escape Sequence Translation                                         CSW209
127000210720     C     csw209        ifeq      'Y'                                                        CSW209
127100210720     C                   exsr      sr_esctr                                                   CSW209
127200210720     C                   endif                                                                CSW209
127300210720      *                                                                                       CSW209
127400210720     C**********         movel     p@msgbuf      APHEAD                                     MD023406
127500210720      *                                                                                     MD023406
127600210720     C                   clear                   w@msgbuf                                   MD023406
127700210720     C                   z-add     1             x                 5 0                      MD023406
127800210720     C                   movea     p@msgbuf      w@msgbuf(x)                                MD023406
127900210720      *                                                                                     MD023406
128000210720      ** Convert carriage return + line feed x'0d15 to x'0d25'                              MD023406
128100210720      *                                                                                     MD023406
128200210720     C     x             doueq     12000                                                    MD023406
128300210720     C                   movea     w@msgbuf(x)   @wk2              2                        MD023406
128400210720     C     @wk2          ifeq      w@altcrlf                                                MD023406
128500210720     C                   movea     w@crlf        w@msgbuf(x)                                MD023406
128600210720     C                   endif                                                              MD023406
128700210720     C                   add       1             x                                          MD023406
128800210720     C                   enddo                                                              MD023406
128900210720     C                   movea     w@msgbuf      p@msgbuf                                   MD023406
129000210720      *
129100210720     C     '{2:'         scan      p@msgbuf      p                 5 0
129200210720     C                   add       3             p
129300210720     C     1             subst     p@msgbuf:p    w@io              1
129400210720     C/COPY WNCPYSRC,MS6110MC10
129500210720      *
129600210720      ** Perform approriate process for Message, Report (ACK / NAK)
129700210720      ** or other (unexpected)
129800210720     C     w@io          caseq     'O'           sr_msg
129900210720     C     w@io          caseq     'I'           sr_rpt
130000210720     C                   cas                     sr_trash
130100210720     C                   endcs
130200210720
130300210720     C                   endif
130400210720     C                   endif
130500210720      *
130600210720      ** Check whether termination has been requested
130700210720     C                   shtdn                                        01
130800210720      *
130900210720     C                   enddo
131000210720      *
131100210720      ** Pop subroutine
131200210720     C                   clear                   @STK(Q)
131300210720     C                   sub       1             Q
131400210720     C                   endsr
131500210720      /EJECT                                                                    CSW025
131600210720      **********************************************************************    CSW025
131700210720      * sr_DQin        : Get incoming Data Queue msgs and write to d/b     *    CSW025
131800210720      * -------                                                            *    CSW025
131900210720      *                                                                    *    CSW025
132000210720      * Called by      : Mainline                                          *    CSW025
132100210720      *                                                                    *    CSW025
132200210720      * Calls            QRCVDTAQ                                          *    CSW025
132300210720      *                  sr_msg                                            *    CSW025
132400210720      *                  sr_rpt                                            *    CSW025
132500210720      *                  sr_trash                                          *    CSW025
132600210720      *                                                                    *    CSW025
132700210720      **********************************************************************    CSW025
132800210720      *                                                                         CSW025
132900210720     C     sr_DQin       begsr                                                  CSW025
133000210720      *                                                                         CSW025
133100210720      ** Push subroutine                                                        CSW025
133200210720     C                   add       1             Q                              CSW025
133300210720     C                   movel     'sr_in'       @STK(Q)                        CSW025
133400210720      *                                                                         CSW025
133500210720      ** Access incoming data until termination requested by user,              CSW025
133600210720      ** or API error.                                                          CSW025
133700210720      *                                                                         CSW025
133800210720     C     *in01         doueq     *on                                          CSW025
133900210720     C     w@abnormal    oreq      'Y'                                          CSW025
134000210720                                                                                CSW025
134100210720      ** Clear message buffer                                                   CSW025
134200210720     C                   clear                   q@DQData                       CSW025
134300210720                                                                                CSW025
134400210720      ** Get message                                                            CSW025
134500210720     C                   call      'QRCVDTAQ'    q@rcvDQpl              99      CSW025
134600210720     C                   eval      p@msgbuf = q@DQData                          CSW025
134700210720                                                                                CSW025
134800210720      ** Trace                                                                  CSW025
134900210720     C                   movel     '*GET   '     PR@FN                          CSW025
135000210720     C                   movel     p@msgbuf      t@tdat                         CSW025
135100210720     C                   exsr      sr_trace                                     CSW025
135200210720                                                                                CSW025
135300210720      ** If receive message failed, indicate abnormal end                       CSW025
135400210720     C                   if        *in99 = *on                                  CSW025
135500210720     C                   movel     'Y'           w@abnormal                     CSW025
135600210720     C                   movel     'DataQueue'   w0file                         CSW025
135700210720     C                   movel     'MEM6001'     w0msgd                         CSW025
135800210720     C                   movel     'MIDAS  '     w0msgf                         CSW025
135900210720     C                   movel     'Rcv message' w0key                          CSW025
136000210720     C                   movel     REASON        w0reas                         CSW025
136100210720     C                   z-add     202           w0ernb                         CSW025
136200210720     C                   else                                                   CSW025
136300210720                                                                                CSW025
136400210720      ** Else, if no error                                                      CSW025
136500210720                                                                                CSW025
136600210720     C     '{2:'         scan      p@msgbuf      p                 5 0          CSW025
136700210720     C                   add       3             p                              CSW025
136800210720     C     1             subst     p@msgbuf:p    w@io              1            CSW025
136900210720                                                                                CSW025
137000210720      ** Perform appropriate process for Message, Report (ACK / NAK)            CSW025
137100210720      ** or other (unexpected)                                                  CSW025
137200210720     C     w@io          caseq     'O'           sr_msg                         CSW025
137300210720     C     w@io          caseq     'I'           sr_rpt                         CSW025
137400210720     C                   cas                     sr_trash                       CSW025
137500210720     C                   endcs                                                  CSW025
137600210720                                                                                CSW025
137700210720     C                   endif                                                  CSW025
137800210720                                                                                CSW025
137900210720      ** Check whether termination has been requested                           CSW025
138000210720     C                   shtdn                                        01        CSW025
138100210720                                                                                CSW025
138200210720     C                   enddo                                                  CSW025
138300210720                                                                                CSW025
138400210720      ** Pop subroutine                                                         CSW025
138500210720     C                   clear                   @STK(Q)                        CSW025
138600210720     C                   sub       1             Q                              CSW025
138700210720     C                   endsr                                                  CSW025
138800210720      /EJECT
138900210720      **********************************************************************                  CSW209
139000210720      * sr_esctr       : Process Escape Sequence Translations              *                  CSW209
139100210720      * ------                                                             *                  CSW209
139200210720      *                                                                    *                  CSW209
139300210720      * Called by      : sr_in                                             *                  CSW209
139400210720      *                                                                    *                  CSW209
139500210720      * Calls          :                                                   *                  CSW209
139600210720      *                                                                    *                  CSW209
139700210720      **********************************************************************                  CSW209
139800210720      *                                                                                       CSW209
139900210720     C     sr_esctr      begsr                                                                CSW209
140000210720      *                                                                                       CSW209
140100210720      ** Push subroutine                                                                      CSW209
140200210720     C                   add       1             Q                                            CSW209
140300210720     C                   movel     'sr_esctr'    @STK(Q)                                      CSW209
140400210720      *                                                                                       CSW209
140500210720     C                   eval      w@f1 = p@msgbuf                                            CSW209
140600210720     C                   eval      z = 1                                                      CSW209
140700210720      *                                                                                       CSW209
140800210720     C                   dow       z < 15                                                     CSW209
140900210720      *                                                                                       CSW209
141000210720     C     ar1(z)        scan      w@f1          w@c1                     89                  CSW209
141100210720     C                   dow       *in89 = *on                                                CSW209
141200210720      *                                                                                       CSW209
141300210720     C                   eval      w@chr = ar2(z)                                             CSW209
141400210720     C                   if        w@c1 = 1                                                   CSW209
141500210720      *                                                                                       CSW209
141600210720     C                   eval      w@c3 = w@c1 + 4                                            CSW209
141700210720     C                   subst     w@f1:w@c3     w@f3                                         CSW209
141800210720     C     w@chr         cat       w@f3:0        w@f4                                         CSW209
141900210720     C                   else                                                                 CSW209
142000210720      *                                                                                       CSW209
142100210720     C                   eval      w@c2 = w@c1 - 1                                            CSW209
142200210720     C     w@c2          subst     w@f1          w@f2                                         CSW209
142300210720     C                   eval      w@c3 = w@c1 + 4                                            CSW209
142400210720     C                   subst     w@f1:w@c3     w@f3                                         CSW209
142500210720     C                   move      *blanks       temp              1                          CSW209
142600210720     C                   move      w@c2          pos               5 0                        CSW209
142700210720     C                   eval      temp = %subst(w@f1:pos)                                    CSW209
142800210720     C                   move      0             ctr               1 0                        CSW209
142900210720     C                   dow       temp = ' '                                                 CSW209
143000210720     C                   add       1             ctr                                          CSW209
143100210720     C                   sub       1             pos                                          CSW209
143200210720     C                   eval      temp=%subst(w@f1:pos)                                      CSW209
143300210720     C                   enddo                                                                CSW209
143400210720     C     w@f2          cat       w@chr:0       w@f2                                         CSW209
143500210720     C     w@f2          cat       w@f3:0        w@f4                                         CSW209
143600210720     C                   endif                                                                CSW209
143700210720      *                                                                                       CSW209
143800210720     C                   eval      w@f1 = w@f4                                                CSW209
143900210720     C                   eval      w@f2 = *blanks                                             CSW209
144000210720     C                   eval      w@f3 = *blanks                                             CSW209
144100210720     C                   eval      w@f4 = *blanks                                             CSW209
144200210720     C     ar1(z)        scan      w@f1          w@c1                     89                  CSW209
144300210720     C                   enddo                                                                CSW209
144400210720      *                                                                                       CSW209
144500210720     C                   eval      z = z + 1                                                  CSW209
144600210720     C                   enddo                                                                CSW209
144700210720      *                                                                                       CSW209
144800210720     C                   eval      p@msgbuf = w@f1                                            CSW209
144900210720      *                                                                                       CSW209
145000210720      ** Pop subroutine                                                                       CSW209
145100210720     C                   clear                   @STK(Q)                                      CSW209
145200210720     C                   sub       1             Q                                            CSW209
145300210720     C                   endsr                                                                CSW209
145400210720      /EJECT                                                                                  CSW209
145500210720      **********************************************************************
145600210720      * sr_msg         : Write incoming message to database                *
145700210720      * ------                                                             *
145800210720      *                                                                    *
145900210720      * Called by      : sr_in                                             *
146000210720      *                                                                    *
146100210720      * Calls          : sr_ix                                             *
146200210720      *                                                                    *
146300210720      **********************************************************************
146400210720      *
146500210720     C     sr_msg        begsr
146600210720      *
146700210720      ** Push subroutine
146800210720     C                   add       1             Q
146900210720     C                   movel     'sr_msg'      @STK(Q)
147000210720      *
147100210720      ** Clear message data file formats
147200210720     C                   clear                   msmsi2d0
147300210720     C                   clear                   msixi2d0
147400210720      *
147500210720      ** Set up Message Input Reference, and check for duplication
147600210720      ** (w@btdta splits up block {2: - see 'D' spec)
147700210720     C     '{2:O'        scan      p@msgbuf      w@1               7 0
147800210720     C                   add       4             w@1
147900210720     C     46            subst     p@msgbuf:w@1  w@b2dta
148000210720     C                   movel     w@mpry        MPRY
148100210720     C                   movel     w@mtpy        MTPY
148200210720      *                                                                                     AR976772
148300210720      ** Set up Century field                                                               AR976772
148400210720     C                   movel     MODE          cent              2                        AR976772
148500210720     C     cent          iflt      '72'                                                     AR976772
148600210720     C                   move      '20'          MODEC                                      AR976772
148700210720     C                   else                                                               AR976772
148800210720     C                   move      '19'          MODEC                                      AR976772
148900210720     C                   endif                                                              AR976772
149000210720      *
149100210720     C     MIR           setll     msmsi2d9                               60
149200210720      *
149300210720      ** If message is not a duplicate and is of a recognised type update
149400210720      ** database
149500210720     C     *in60         ifeq      *off
149600210720     C     w@mtpy        andge     '100'
149700210720     C     w@mtpy        andle     '999'
149800210720     C     w@96n         andne     '96'
149900210720      *
150000210720      ** Set up the MOR date from the incoming date
150100210720     C                   move      MODE          w@mord
150200210720      *
150300210720      ** Locate Block {1: of the message for the remaining
150400210720      ** components of the MOR
150500210720     C     '{1:'         scan      p@msgbuf      w@1
150600210720     C                   add       6             w@1
150700210720     C     22            subst     p@msgbuf:w@1  w@morr
150800210720      *
150900210720      ** Create message index
151000210720     C                   exsr      sr_ix
151100210720      *
151200210720      ** Set message-processed flag
151300210720     C                   movel     'Y'           MSPF
151400210720      *
151500210720      ** Write all data records to message data file
151600210720     C                   z-add     1             w@1
151700210720     C     256           subst     p@msgbuf      MDTA
151800210720     C     MDTA          downe     *blanks
151900210720     C                   write     msmsi2d0
152000210720     C                   add       256           w@1
152100210720     C     256           subst     p@msgbuf:w@1  MDTA
152200210720     C                   enddo
152300210720      *
152400210720      ** Prompt Incoming Message Management
152500210720     C                   callb     'MEC1024M'                           9090
152600210720     C                   parm      *blanks       p@rtcd            7
152700210720      *
152800210720      ***Update*received*network*information                                                AR989496
152900210720     C******dtaara       define                  medta                                      AR989496
153000210720     C******lock         in        medta                                                    AR989496
153100210720     C**********         movel     MOR           DAMOR                                      AR989496
153200210720     C**********         movel     MIR           DAMIR                                      AR989496
153300210720     C**********         out       medta
153400210720      *
153500210720     C                   endif
153600210720      *
153700210720      ** Commit transaction (message) : all data + index
153800210720     C                   commit
153900210720      *
154000210720      ** Pop subroutine
154100210720     C                   clear                   @STK(Q)
154200210720     C                   sub       1             Q
154300210720     C                   endsr
154400210720      /EJECT
154500210720      **********************************************************************
154600210720      * sr_ix          : Generate index (reference) record for incoming    *
154700210720      * -----            message.                                          *
154800210720      *                                                                    *
154900210720      * Called by      : sr_msg                                            *
155000210720      *                                                                    *
155100210720      * Calls          : sr_typa                                           *
155200210720      *                  sr_typb                                           *
155300210720      *                  sr_typc                                           *
155400210720      *                  sr_typd                                           *
155500210720      *                  sr_type                                           *                  CSW212
155600210720      *                                                                    *
155700210720      **********************************************************************
155800210720      *
155900210720     C     sr_ix         begsr
156000210720      *
156100210720      ** Push subroutine
156200210720     C                   add       1             Q
156300210720     C                   movel     'sr_ix'       @STK(Q)
156400210720      *
156500210720      ** Attempt to match destination address with branch address details
156600210720      ** from Branch Codes file to determine Midas branch.
156700210720     C                   movel     w@dstad       w@try            11
156800210720     C                   move      w@dstbr       w@try
156900210720     C                   z-add     1             w@b
157000210720     C     w@try         lookup    br@swift(w@b)                          80
157100210720     C     *in80         ifeq      *on
157200210720     C                   movel     br@midas(w@b) BRCA
157300210720     C                   endif
157400210720      ** If BIC code ends in 'XXX' then use default branch                                    252317
157500210720      **    and not found in the SDBRCHPD file                                                252317
157600210720     C                   if        *in80  = *off and                                          252317
157700210720     C                             w@brbr = 'XXX'                                             252317
157800210720     C                   move      dftbrch       BRCA                                         252317
157900210720     C                   end                                                                  252317
158000210720      *
158100210720      ** Attempt to locate Midas customer number: if found, store 'suppress
158200210720      ** download to AutoRecs II' flag.
158300210720     C                   move      w@sndad       k@cliad
158400210720     C                   move      w@sndbr       k@clibr
158500210720     C                   clear                   w@ssdl            1
158600210720     C     k@clikey      chain     sdcustl7                           81
158700210720     C     *in81         ifeq      *on
158800210720     C     k@clibr       andeq     'XXX'
158900210720     C                   clear                   k@clibr
159000210720     C     k@clikey      chain     sdcustl7                           81
159100210720     C                   endif
159200210720     C     *in81         ifeq      *off
159300210720     C                   move      BBCUST        CNUM
159400210720     C                   move      BBSSDL        w@ssdl
159500210720     C/COPY WNCPYSRC,MS6110MC15
159600210720     C                   endif
159700210720     C                   move      k@clikey      STID
159800210720      *
159900210720      ** Locate TRN
160000210720     C     ':20:'        scan      p@msgbuf      w@1                      65                  140532
160100210720     C     *in65         ifeq      *off                                                       140532
160200210720     C     ':20C:'       scan      p@msgbuf      w@1                      65                  140532
160300210720     C                   add       8             w@1                                          140532
160400210720     C                   endif                                                                140532
160500210720      *
160600210720      ** Scan for the end of the TRN
160700210720     C     w@crlf        scan      p@msgbuf:w@1  w@2               7 0
160800210720      *
160900210720      ** If that doesn't find it, try the alternative CR/LF encoding            CSW038
161000210720     C                   if        w@2 = 0                                      CSW038
161100210720     C     w@altcrlf     scan      p@msgbuf:w@1  w@2                            CSW038
161200210720     C                   endif                                                  CSW038
161300210720                                                                                CSW038
161400210720      ** Calculate the length of the TRN
161500210720     C                   add       4             w@1
161600210720     C     w@2           sub       w@1           w@ln              7 0
161700210720      *
161800210720      ** Move the TRN into the reference record field
161900210720     C                   clear                   w@trno           16
162000210720     C     w@ln          subst     p@msgbuf:w@1  w@trno
162100210720      *
162200210720      ** Determine message type, and process appropriately
162300210720     C     MTPY          lookup    tabtyp        tabcas                   82
162400210720     C     *in82         ifeq      *on
162500210720     C     tabcas        caseq     'A'           sr_typa
162600210720     C     tabcas        caseq     'B'           sr_typb
162700210720     C     tabcas        caseq     'C'           sr_typc
162800210720     C     tabcas        caseq     'D'           sr_typd
162900210720     C     tabcas        caseq     'E'           sr_type                                      CSW212
163000210720     C                   end
163100210720     C                   else
163200210720     C                   clear                   FD25
163300210720     C                   clear                   SVDT
163400210720     C                   clear                   AMTS
163500210720     C                   clear                   CCY
163600210720     C                   endif
163700210720      *
163800210720      ** Perform AutoRecs II processing if module is switched on
163900210720     C     BGAURC        ifeq      'Y'
164000210720      *
164100210720      ** If message is statement (940, 950) and 'suppress download to
164200210720      ** AutoRecs II' is not set for customer, set up download details.
164300210720     C     MTPY          ifeq      '940'
164400210720     C     w@ssdl        andne     'Y'
164500210720     C     MTPY          oreq      '950'
164600210720     C     w@ssdl        andne     'Y'
164700210720     C                   TIME                    R3STIM
164800210720     C                   movel     'A'           R3RPTS
164900210720     C                   z-add     BJRDNB        R3SDAT
165000210720     C                   movel     ##JOB         R3LJOB
165100210720     C                   movel     ##USR         R3LUSR
165200210720     C                   movel     ##JNO         R3LJNO
165300210720     C                   endif
165400210720      *
165500210720     C                   endif
165600210720      *
165700210720      ** Output record to MSIXI2PD
165800210720     C                   move      w@trno        TRNO
165900210720                                                                                             BUG4717
166000210720      ** Populate Output Date Century field                                                  BUG4717
166100210720     C                   MOVEL     '20'          MODEC                                       BUG4717
166200210720                                                                                              CTI004
166300210720      ** IF CTI004 is installed, check message type                                           CTI004
166400210720                                                                                              CTI004
166500210720     C                   IF        CTI004 =  'Y'                                              CTI004
166600210720     C                   CALL      'MS6200'                                                   CTI004
166700210720     C                   PARM      MTPY          PMTPY                                        CTI004
166800210720     C                   PARM      p@msgbuf      PMSGBUF                                      CTI004
166900210720     C                   PARM      ' '           POKFLG                                       CTI004
167000210720                                                                                              CTI004
167100210720     C                   IF        POKFLG = 'Y'                                               CTI004
167200210720     C                   EVAL      IMPF = 'P'                                                 CTI004
167300210720     C                   EVAL      LSTS = 'T'                                                 CTI004
167400210720     C                   ENDIF                                                                CTI004
167500210720                                                                                              CTI004
167600210720     C                   ENDIF                                                                CTI004
167700210720                                                                                              CTI004
167800210720     C                   write     msixi2d0
167900210720      *
168000210720      ** Pop subroutine
168100210720     C                   clear                   @STK(Q)
168200210720     C                   sub       1             Q
168300210720     C                   endsr
168400210720      /EJECT
168500210720      **********************************************************************
168600210720      * sr_typa        : Process incoming messages of type A: 100, 200,    *
168700210720      * -------          202, 300, 320, 324, 330, 900, 910.                *
168800210720      *                  600.                                              *                  CSW212
168900210720      *                                                                    *
169000210720      * Called by      : sr_ix                                             *
169100210720      *                                                                    *
169200210720      * Calls          : -                                                 *
169300210720      *                                                                    *
169400210720      **********************************************************************
169500210720      *
169600210720     C     sr_typa       begsr
169700210720      *
169800210720      ** Push subroutine
169900210720     C                   add       1             Q
170000210720     C                   movel     'sr_typa'     @STK(Q)
170100210720      *
170200210720      ** No field :25:
170300210720     C                   clear                   FD25
170400210720      *                                                                                       123750
170500210720      ** If message is post-1997 MT300 extract value date from field :30V:                    123750
170600210720      ** (Date is CCYYMMDD format; use offset of 7 to extract YYMMDD.)                        123750
170700210720      ** As above for post-2000 MT320, MT330                                                  184013
170800210720      ** As above for MT360, MT361, MT362                                                     184427
170900210720     C     MTPY          ifeq      '300'                                                      123750
171000210720     C     MTPY          oreq      '320'                                                      184013
171100210720     C     MTPY          oreq      '330'                                                      184013
171200210720     C     MTPY          oreq      '360'                                                      184427
171300210720     C     MTPY          oreq      '361'                                                      184427
171400210720     C     MTPY          oreq      '362'                                                      184427
171500210720     C     ':30V:'       scan      p@msgbuf      w@1                      83                  123750
171600210720     C                   endif                                                                123750
171700210720      *                                                                                       184427
171800210720      ** If message is MT340 or MT341 extract value date from field :30F:                     184427
171900210720      ** (Date is CCYYMMDD format; use offset of 7 to extract YYMMDD.)                        184427
172000210720     C     MTPY          ifeq      '340'                                                      184427
172100210720     C     MTPY          oreq      '341'                                                      184427
172200210720     C     ':30F:'       scan      p@msgbuf      w@1                      83                  184427
172300210720     C                   endif                                                                184427
172400210720      *                                                                                       123750
172500210720     C     MTPY          ifeq      '300'                                                      123750
172600210720     C     *in83         andeq     *on                                                        123750
172700210720     C     MTPY          oreq      '320'                                                      184013
172800210720     C     *in83         andeq     *on                                                        184013
172900210720     C     MTPY          oreq      '330'                                                      184013
173000210720     C     *in83         andeq     *on                                                        184013
173100210720     C     MTPY          oreq      '340'                                                      184427
173200210720     C     *in83         andeq     *on                                                        184427
173300210720     C     MTPY          oreq      '341'                                                      184427
173400210720     C     *in83         andeq     *on                                                        184427
173500210720     C     MTPY          oreq      '360'                                                      184427
173600210720     C     *in83         andeq     *on                                                        184427
173700210720     C     MTPY          oreq      '361'                                                      184427
173800210720     C     *in83         andeq     *on                                                        184427
173900210720     C     MTPY          oreq      '362'                                                      184427
174000210720     C     *in83         andeq     *on                                                        184427
174100210720     C                   add       7             w@1                                          123750
174200210720     C     6             subst     p@msgbuf:w@1  SVDT                                         123750
174300210720     C     MTPY          ifeq      '362'                                                      184427
174400210720     C     ':32M:'       scan      p@msgbuf      w@1                                          184427
174500210720     C                   else                                                                 184427
174600210720     C     ':32B:'       scan      p@msgbuf      w@1                                          123750
174700210720     C                   end                                                                  184427
174800210720     C                   add       5             w@1                                          123750
174900210720     C                   else                                                                 123750
175000210720      *                                                                                       CSW212
175100210720     C     MTPY          ifeq      '600'                                                      CSW212
175200210720     C                   movel     ':34'         w@stag                                       CSW212
175300210720     C                   else                                                                 CSW212
175400210720      *
175500210720      ** Find field :32a:
175600210720     C                   movel     ':32'         w@stag                                       125554
175700210720     C                   endif                                                                CSW212
175800210720     C     w@scan        scan      p@msgbuf      w@1                                          125554
175900210720     C                   add       2             w@1                                          125554
176000210720      *
176100210720      ** Extract value date
176200210720     C                   add       5             w@1
176300210720     C     6             subst     p@msgbuf:w@1  SVDT
176400210720      *
176500210720      ** Extract currency
176600210720     C                   add       6             w@1
176700210720     C                   endif                                                                123750
176800210720      *                                                                                     AR976772
176900210720      ** Extract value date century                                                         AR976772
177000210720      *                                                                                     AR976772
177100210720     C     2             subst     SVDT:1        w@vdyy            2                        AR976772
177200210720     C     w@vdyy        iflt      '72'                                                     AR976772
177300210720     C                   movel     '20'          SVDTC                                      AR976772
177400210720     C                   else                                                               AR976772
177500210720     C                   movel     '19'          SVDTC                                      AR976772
177600210720     C                   endif                                                              AR976772
177700210720     C     3             subst     p@msgbuf:w@1  CCY
177800210720      *
177900210720      ** Extract amount
178000210720     C                   clear                   AMTS
178100210720     C                   add       3             w@1
178200210720     C     w@crlf        scan      p@msgbuf:w@1  w@2
178300210720                                                                                CSW038
178400210720      ** If that doesn't find it, try the alternative CR/LF encoding            CSW038
178500210720     C                   if        w@2 = 0                                      CSW038
178600210720     C     w@altcrlf     scan      p@msgbuf:w@1  w@2                            CSW038
178700210720     C                   endif                                                  CSW038
178800210720                                                                                CSW038
178900210720     C     w@2           sub       w@1           w@ln
179000210720     C     w@ln          subst     p@msgbuf:w@1  AMTS
179100210720      *
179200210720      ** Pop subroutine
179300210720     C                   clear                   @STK(Q)
179400210720     C                   sub       1             Q
179500210720     C                   endsr
179600210720      /EJECT
179700210720      **********************************************************************
179800210720      * sr_typb        : Process incoming messages of type B: 201, 203.    *
179900210720      * -------                                                            *
180000210720      *                                                                    *
180100210720      * Called by      : sr_ix                                             *
180200210720      *                                                                    *
180300210720      * Calls          : -                                                 *
180400210720      *                                                                    *
180500210720      **********************************************************************
180600210720      *
180700210720     C     sr_typb       begsr
180800210720      *
180900210720      ** Push subroutine
181000210720     C                   add       1             Q
181100210720     C                   movel     'sr_typb'     @STK(Q)
181200210720      *
181300210720      ** No field :25:
181400210720     C                   clear                   FD25
181500210720      *
181600210720      *
181700210720      ** Find field :19: and extract amount
181800210720     C                   movel     ':19'         w@stag                                       125554
181900210720     C     w@scan        scan      p@msgbuf      w@1                                          125554
182000210720     C                   add       2             w@1                                          125554
182100210720     C*                                                                                       125554
182200210720     C                   clear                   AMTS
182300210720     C                   add       4             w@1
182400210720     C     w@crlf        scan      p@msgbuf:w@1  w@2
182500210720                                                                                CSW038
182600210720      ** If that doesn't find it, try the alternative CR/LF encoding            CSW038
182700210720     C                   if        w@2 = 0                                      CSW038
182800210720     C     w@altcrlf     scan      p@msgbuf:w@1  w@2                            CSW038
182900210720     C                   endif                                                  CSW038
183000210720                                                                                CSW038
183100210720     C     w@2           sub       w@1           w@ln
183200210720     C     w@ln          subst     p@msgbuf:w@1  AMTS
183300210720      *
183400210720      ** Find field :30: and extract value date
183500210720     C                   movel     ':30'         w@stag                                       125554
183600210720     C     w@scan        scan      p@msgbuf      w@1                                          125554
183700210720     C                   add       2             w@1                                          125554
183800210720     C*                                                                                       125554
183900210720     C                   add       4             w@1
184000210720     C     6             subst     p@msgbuf:w@1  SVDT
184100210720      *
184200210720      ** Find field :32: and extract currency
184300210720     C                   movel     ':32'         w@stag                                       125554
184400210720     C     w@scan        scan      p@msgbuf      w@1                                          125554
184500210720     C                   add       2             w@1                                          125554
184600210720     C*                                                                                       125554
184700210720     C                   add       4             w@1
184800210720     C     3             subst     p@msgbuf:w@1  CCY
184900210720      *                                                                                     AR976772
185000210720      ** Extract value date century                                                         AR976772
185100210720      *                                                                                     AR976772
185200210720     C     2             subst     SVDT:1        w@vdyy                                     AR976772
185300210720     C     w@vdyy        iflt      '72'                                                     AR976772
185400210720     C                   movel     '20'          SVDTC                                      AR976772
185500210720     C                   else                                                               AR976772
185600210720     C                   movel     '19'          SVDTC                                      AR976772
185700210720     C                   endif                                                              AR976772
185800210720      *
185900210720      ** Pop subroutine
186000210720     C                   clear                   @STK(Q)
186100210720     C                   sub       1             Q
186200210720     C                   endsr
186300210720      /EJECT
186400210720      **********************************************************************
186500210720      * sr_typc        : Process incoming messages of type C: 950, 940.    *
186600210720      * -------                                                            *
186700210720      *                                                                    *
186800210720      * Called by      : sr_ix                                             *
186900210720      *                                                                    *
187000210720      * Calls          : -                                                 *
187100210720      *                                                                    *
187200210720      **********************************************************************
187300210720      *
187400210720     C     sr_typc       begsr
187500210720      *
187600210720      ** Push subroutine
187700210720     C                   add       1             Q
187800210720     C                   movel     'sr_typc'     @STK(Q)
187900210720      *
188000210720      ** Find field :25: and extract account details
188100210720     C                   clear                   FD25
188200210720     C                   movel     ':25'         w@stag                                       125554
188300210720     C     w@scan        scan      p@msgbuf      w@1                                          125554
188400210720     C                   add       2             w@1                                          125554
188500210720     C*                                                                                       125554
188600210720     C                   clear                   AMTS
188700210720     C                   add       4             w@1
188800210720     C     w@crlf        scan      p@msgbuf:w@1  w@2
188900210720                                                                                CSW038
189000210720      ** If that doesn't find it, try the alternative CR/LF encoding            CSW038
189100210720     C                   if        w@2 = 0                                      CSW038
189200210720     C     w@altcrlf     scan      p@msgbuf:w@1  w@2                            CSW038
189300210720     C                   endif                                                  CSW038
189400210720                                                                                CSW038
189500210720     C     w@2           sub       w@1           w@ln
189600210720     C     w@ln          subst     p@msgbuf:w@1  FD25
189700210720      *
189800210720      ** Clear remaining details
189900210720     C                   clear                   SVDT
190000210720     C                   clear                   AMTS
190100210720     C                   clear                   CCY
190200210720      *
190300210720      ** Pop subroutine
190400210720     C                   clear                   @STK(Q)
190500210720     C                   sub       1             Q
190600210720     C                   endsr
190700210720      /EJECT
190800210720      **********************************************************************
190900210720      * sr_typd        : Process incoming messages of type D: 350.         *
191000210720      * -------                                                            *
191100210720      *                                                                    *
191200210720      * Called by      : sr_ix                                             *
191300210720      *                                                                    *
191400210720      * Calls          : -                                                 *
191500210720      *                                                                    *
191600210720      **********************************************************************
191700210720      *
191800210720     C     sr_typd       begsr
191900210720      *
192000210720      ** Push subroutine
192100210720     C                   add       1             Q
192200210720     C                   movel     'sr_typd'     @STK(Q)
192300210720      *
192400210720      ** No field :25:
192500210720     C                   clear                   FD25
192600210720      ** Extract value date from field :30V:                                                  184013
192700210720      ** (Date is CCYYMMDD format; use offset of 7 to extract YYMMDD.)                        184013
192800210720      *                                                                                       184013
192900210720     C     ':30V:'       scan      p@msgbuf      w@1                      83                  184013
193000210720      *                                                                                       184013
193100210720     C     *in83         ifeq      *on                                                        184013
193200210720     C                   add       7             w@1                                          184013
193300210720     C     6             subst     p@msgbuf:w@1  SVDT                                         184013
193400210720     C     ':34B:'       scan      p@msgbuf      w@1                                          184013
193500210720     C                   add       5             w@1                                          184013
193600210720     C                   else                                                                 184013
193700210720      *
193800210720      ** Find field :34P:
193900210720     C                   movel     ':34'         w@stag                                       125554
194000210720     C     w@scan        scan      p@msgbuf:w@1  w@1                                          125554
194100210720     C                   add       2             w@1                                          125554
194200210720      *
194300210720      *
194400210720      ** Extract value date
194500210720     C                   add       5             w@1
194600210720     C     6             subst     p@msgbuf:w@1  SVDT
194700210720      *
194800210720      ** Extract currency
194900210720     C                   add       6             w@1
195000210720     C                   endif                                                                184013
195100210720     C     3             subst     p@msgbuf:w@1  CCY
195200210720      *
195300210720      ** Extract amount
195400210720     C                   clear                   AMTS
195500210720     C                   add       3             w@1
195600210720     C     w@crlf        scan      p@msgbuf:w@1  w@2
195700210720                                                                                CSW038
195800210720      ** If that doesn't find it, try the alternative CR/LF encoding            CSW038
195900210720     C                   if        w@2 = 0                                      CSW038
196000210720     C     w@altcrlf     scan      p@msgbuf:w@1  w@2                            CSW038
196100210720     C                   endif                                                  CSW038
196200210720                                                                                CSW038
196300210720     C     w@2           sub       w@1           w@ln
196400210720     C     w@ln          subst     p@msgbuf:w@1  AMTS
196500210720      *                                                                                     AR976772
196600210720      ** Extract value date century                                                         AR976772
196700210720      *                                                                                     AR976772
196800210720     C     2             subst     SVDT:1        w@vdyy                                     AR976772
196900210720     C     w@vdyy        iflt      '72'                                                     AR976772
197000210720     C                   movel     '20'          SVDTC                                      AR976772
197100210720     C                   else                                                               AR976772
197200210720     C                   movel     '19'          SVDTC                                      AR976772
197300210720     C                   endif                                                              AR976772
197400210720      *
197500210720      ** Pop subroutine
197600210720     C                   clear                   @STK(Q)
197700210720     C                   sub       1             Q
197800210720     C                   endsr
197900210720      /EJECT
198000210720      **********************************************************************                  CSW212
198100210720      * sr_type        : Process incoming messages of type E: 370.         *                  CSW212
198200210720      * -------                                                            *                  CSW212
198300210720      *                                                                    *                  CSW212
198400210720      * Called by      : sr_ix                                             *                  CSW212
198500210720      * Calls          : None                                              *                  CSW212
198600210720      *                                                                    *                  CSW212
198700210720      **********************************************************************                  CSW212
198800210720                                                                                              CSW212
198900210720     C     sr_type       BEGSR                                                                CSW212
199000210720                                                                                              CSW212
199100210720     C                   add       1             Q                                            CSW212
199200210720     C                   movel     'sr_type'     @STK(Q)                                      CSW212
199300210720                                                                                              CSW212
199400210720      ** Check for field :19A:                                                                CSW212
199500210720                                                                                              CSW212
199600210720     C     MTPY          lookup    tabty2        tabamc                   82                  CSW212
199700210720                                                                                              CSW212
199800210720     C     *in82         ifeq      *on                                                        CSW212
199900210720     C     tabamc        scan      p@msgbuf      w@1                      83                  CSW212
200000210720     C                   else                                                                 CSW212
200100210720     C     ':19A:'       scan      p@msgbuf      w@1                      83                  CSW212
200200210720     C                   endif                                                                CSW212
200300210720                                                                                              CSW212
200400210720      ** Extract Currency and Amount                                                          CSW212
200500210720                                                                                              CSW212
200600210720     C     *in83         ifeq      *on                                                        CSW212
200700210720     C                   add       12            w@1                                          CSW212
200800210720     C                   z-add     0             t@1               7 0                        CSW212
200900210720     C     w@1           add       3             t@1                                          CSW212
201000210720     C                   movel     *BLANKS       w@testn           1                          CSW212
201100210720     C                   subst     p@msgbuf:t@1  w@testn                                      CSW212
201200210720     C     digits        check     w@testn                                84                  CSW212
201300210720     C     *in84         ifeq      *on                                                        CSW212
201400210720     C                   add       1             w@1                                          CSW212
201500210720     C                   endif                                                                CSW212
201600210720                                                                                              CSW212
201700210720     C     3             subst     p@msgbuf:w@1  CCY                                          CSW212
201800210720     C                   add       3             w@1                                          CSW212
201900210720                                                                                              CSW212
202000210720     C                   clear                   AMTS                                         CSW212
202100210720     C     w@crlf        scan      p@msgbuf:w@1  w@2                                          CSW212
202200210720     C     w@2           sub       w@1           w@ln                                         CSW212
202300210720     C     w@ln          subst     p@msgbuf:w@1  AMTS                                         CSW212
202400210720     C                   endif                                                                CSW212
202500210720                                                                                              CSW212
202600210720      ** Check for field :98A:                                                                CSW212
202700210720                                                                                              CSW212
202800210720     C     MTPY          LOOKUP    tabty3        tabdat                   82                  CSW212
202900210720                                                                                              CSW212
203000210720     C     *in82         ifeq      *on                                                        CSW212
203100210720     C     tabdat        scan      p@msgbuf      w@1                      83                  CSW212
203200210720     C                   else                                                                 CSW212
203300210720     C     ':98A:'       scan      p@msgbuf      w@1                      83                  CSW212
203400210720     C                   endif                                                                CSW212
203500210720                                                                                              CSW212
203600210720      ** Extract Value date                                                                   CSW212
203700210720                                                                                              CSW212
203800210720     C     *in83         ifeq      *on                                                        CSW212
203900210720     C                   add       12            w@1                                          CSW212
204000210720     C     2             subst     p@msgbuf:w@1  SVDTC                                        CSW212
204100210720     C                   add       2             w@1                                          CSW212
204200210720     C     6             subst     p@msgbuf:w@1  SVDT                                         CSW212
204300210720     C                   endif                                                                CSW212
204400210720                                                                                              CSW212
204500210720     C                   clear                   FD25                                         CSW212
204600210720                                                                                              CSW212
204700210720     C                   clear                   @STK(Q)                                      CSW212
204800210720     C                   sub       1             Q                                            CSW212
204900210720     C                   endsr                                                                CSW212
205000210720      **********************************************************************                  CSW212
205100210720      /EJECT                                                                                  CSW212
205200210720      **********************************************************************
205300210720      * sr_rpt         : Process Report (ACK / NAK)                        *
205400210720      * ------                                                             *
205500210720      *                                                                    *
205600210720      * Called by      : sr_in                                             *
205700210720      *                                                                    *
205800210720      * Calls          : -                                                 *
205900210720      *                                                                    *
206000210720      **********************************************************************
206100210720      *
206200210720     C     sr_rpt        begsr
206300210720      *
206400210720      ** Push subroutine
206500210720     C                   add       1             Q
206600210720     C                   movel     'sr_rpt'      @STK(Q)
206700210720      *
206800210720      ** Clear message data file format
206900210720     C                   clear                   msmsi2d0
207000210720      *
207100210720      ** Access reference record for this message using TRN from field :20:
207200210720      ** if found
207300210720     C     ':20:'        scan      p@msgbuf      w@1                      78
207400210720     C/COPY WNCPYSRC,MS6110MC11
207500210720     C     *in78         ifeq      *on
207600210720      *
207700210720     C     w@crlf        scan      p@msgbuf:w@1  w@2
207800210720                                                                                CSW038
207900210720      ** If that doesn't find it, try the alternative CR/LF encoding            CSW038
208000210720     C                   if        w@2 = 0                                      CSW038
208100210720     C     w@altcrlf     scan      p@msgbuf:w@1  w@2                            CSW038
208200210720     C                   endif                                                  CSW038
208300210720                                                                                CSW038
208400210720     C/COPY WNCPYSRC,MS6110MC12
208500210720     C                   add       4             w@1
208600210720     C     w@2           sub       w@1           w@ln
208700210720     C     w@ln          subst(p)  p@msgbuf:w@1  w@trno
208800210720     C     w@trno        chain     mgorefd0                           70
208900210720     C     *in70         ifeq      *off
209000210720     C     TRNF          andne     *blanks
209100210720     C     TRNF          chain     mgorefd0                           70
209200210720     C                   endif
209300210720      *
209400210720      ** If original message still exists, write ACK / NAK details
209500210720     C     *in70         ifeq      *off
209600210720      *
209700210720      ** Find the ACK / NAK date and time in field {177:YYMMDDHHMM}
209800210720     C     '{177:'       scan      p@msgbuf      w@1
209900210720     C                   add       5             w@1
210000210720     C     6             subst     p@msgbuf:w@1  w@mode
210100210720     C                   movel     w@mode        MODE
210200210720     C                   add       6             w@1
210300210720     C     4             subst     p@msgbuf:w@1  w@motm
210400210720     C                   movel     w@motm        MOTM
210500210720      *
210600210720      ** Set up last action date and time and MIR
210700210720     C                   movel(p)  w@day         LADT
210800210720     C     w@month       lookup    tabmonn       tabmona                  77
210900210720     C     LADT          cat       tabmona:0     LADT
211000210720     C     LADT          cat       w@year:0      LADT
211100210720     C                   z-add     w@latm        LATM
211200210720      *
211300210720     C     22            subst     p@msgbuf:7    w@an_mir         22
211400210720     C                   movel(p)  MODE          MIR
211500210720     C     MIR           cat       w@an_mir:0    MIR
211600210720      *
211700210720      ** Find the Accept-Reject code in field {451:n}, and set up data
211800210720      ** and reference fields accordingly
211900210720     C     '{451:'       scan      p@msgbuf      w@1
212000210720     C                   add       5             w@1
212100210720     C     1             subst     p@msgbuf:w@1  w@acknak          1
212200210720     C     w@acknak      ifeq      '0'
212300210720     C                   move      'A'           ACNK
212400210720     C                   move      '3'           MGSG
212500210720     C                   move      'LACK'        MGST
212600210720     C                   clear                   MSE1
212700210720     C                   clear                   ELIN
212800210720     C                   else
212900210720     C                   move      'N'           ACNK
213000210720     C                   move      '4'           MGSG
213100210720     C                   move      'NACK'        MGST
213200210720      *
213300210720      ** If this is a NAK, extract the error code details
213400210720     C     '{405:'       scan      p@msgbuf      w@1
213500210720     C                   add       5             w@1
213600210720     C     3             subst     p@msgbuf:w@1  MSE1
213700210720     C                   add       3             w@1
213800210720     C     3             subst     p@msgbuf:w@1  ELIN
213900210720     C                   endif
214000210720      *
214100210720      ** Output 1st record of ACK / NAK to MSMSI2PD and update
214200210720      ** reference
214300210720     C                   movel     p@msgbuf      MDTA
214400210720     C/COPY WNCPYSRC,MS6110MC13
214500210720     C                   write     msmsi2d0
214600210720     C/COPY WNCPYSRC,MS6110MC14
214700210720     C                   update    mgorefd0
214800210720      *
214900210720     C                   endif
215000210720     C                   endif
215100210720      *
215200210720      ** Commit transaction : (N)ACK data + reference file update
215300210720     C                   commit
215400210720      *
215500210720      ** Pop subroutine
215600210720     C                   clear                   @STK(Q)
215700210720     C                   sub       1             Q
215800210720     C                   endsr
215900210720      /EJECT
216000210720      **********************************************************************
216100210720      * sr_trash       : Process unexpected data received in *INCOMING     *
216200210720      * --------         mode                                              *
216300210720      *                                                                    *
216400210720      * Called by      : sr_in                                             *
216500210720      *                                                                    *
216600210720      * Calls          : -                                                 *
216700210720      *                                                                    *
216800210720      **********************************************************************
216900210720      *
217000210720     C     sr_trash      begsr
217100210720      *
217200210720      ** Push subroutine
217300210720     C                   add       1             Q
217400210720     C                   movel     'sr_trash'    @STK(Q)
217500210720      *
217600210720      ** NULL (may wish to add code here to log erroneous data)
217700210720      *
217800210720      ** Pop subroutine
217900210720     C                   clear                   @STK(Q)
218000210720     C                   sub       1             Q
218100210720     C                   endsr
218200210720      /EJECT
218300210720      **********************************************************************
218400210720      * sr_term        : Program termination                               *
218500210720      * -------                                                            *
218600210720      *                                                                    *
218700210720      * Called by      : Mainline                                          *
218800210720      *                                                                    *
218900210720      * Calls          : sr_close                                          *
219000210720      *                                                                    *
219100210720      **********************************************************************
219200210720      *
219300210720     C     sr_term       begsr
219400210720      *
219500210720      ** Push subroutine
219600210720     C                   add       1             Q
219700210720     C                   movel     'sr_term'     @STK(Q)
219800210720      *
219900210720      ** Shutdown compression server for transmission jobs if not
220000210720      ** already requested
220100210720     C     p@io          ifeq      'O'
220200210720     C     w@srvr_trq    andeq     'N'
220300210720     C                   movel(p)  '*SHUTDOWN'   q@prompt
220400210720     C                   call      'QSNDDTAQ'    q@snddtaq
220500210720     C                   movel     'Y'           w@srvr_trq
220600210720     C                   endif
220700210720      *
220800210720      ** Close MQ series queue (if it was opened)
220900210720      *
221000210720     C     w@open        ifeq      'Y'
221100210720
221200210720     C                   exsr      sr_close
221300210720     C     w@connect     ifeq      'Y'                                                        245310
221400210720     C                   exsr      sr_disconn                                                 245310
221500210720     C                   endif                                                                245310
221600210720     C                   endif
221700210720      *
221800210720      ** Perform abnormal termination processing if required:
221900210720      *
222000210720     C     w@abnormal    ifeq      'Y'
222100210720      *
222200210720      **  - print error report
222300210720     C     w@prtopn      ifne      'Y'
222400210720     C                   open      ms6110au
222500210720     C                   movel     'Y'           w@prtopn
222600210720     C                   endif
222700210720     C                   write     ms6110f1
222800210720     C                   write     ms6110f2
222900210720     C                   write     ms6110f3
223000210720     C                   close     ms6110au
223100210720      *
223200210720      **  - send error message and terminate abnormally
223300210720     C                   exsr      srerr
223400210720      *
223500210720     C                   endif
223600210720      *
223700210720      ** Pop subroutine
223800210720     C                   clear                   @STK(Q)
223900210720     C                   sub       1             Q
224000210720     C                   endsr
224100210720      /EJECT
224200210720      **********************************************************************
224300210720      * sr_init        : Initialise program                                *
224400210720      * -------                                                            *
224500210720      *                                                                    *
224600210720      * Called by      : Mainline                                          *
224700210720      *                                                                    *
224800210720      * Calls          : sr_open                                           *
224900210720      *                  AOSARDR0                                          *                  CSW025
225000210720      *                                                                    *
225100210720      **********************************************************************
225200210720      *
225300210720     C     sr_init       begsr
225400210720      *
225500210720      ** Push subroutine
225600210720     C                   add       1             Q
225700210720     C                   movel     'sr_init'     @STK(Q)
225800210720      *
225900210720      ** Define data areas
226000210720     C     *dtaara       define                  msstat
226100210720     C     *dtaara       define                  sdstat
226200210720     C/COPY WNCPYSRC,MS6110MC04
226300210720      *
226400210720      ** Define parameter lists
226500210720     C     q@rcvdtaq     plist
226600210720     C                   parm      p@dtqm        q@dtaq           10
226700210720     C                   parm      '*LIBL'       q@libl           10
226800210720     C                   parm      12050         q@length          5 0
226900210720     C                   parm                    q@dqm
227000210720     C                   parm      -1            q@wait            5 0
227100210720      *
227200210720     C     q@snddtaq     plist
227300210720     C                   parm      p@dtqc        q@dtaq
227400210720     C                   parm      '*LIBL'       q@libl
227500210720     C                   parm      50            q@length          5 0
227600210720     C                   parm                    q@dqc
227700210720                                                                                CSW025
227800210720      * parameter lists for put/get to final Data Queues                        CSW025
227900210720     C     q@sndDQpl     plist                                                  CSW025
228000210720     C                   parm                    q@DQNameOut      10            CSW025
228100210720     C                   parm      '*LIBL'       q@DQLibl         10            CSW025
228200210720     C                   parm      12000         q@DQLength        5 0          CSW025
228300210720     C                   parm                    q@DQData      12000            CSW025
228400210720     C                   parm      4             q@klength         3 0                        CSW034
228500210720     C                   parm                    q@skey            4                          CSW034
228600210720                                                                                CSW025
228700210720     C     q@rcvDQpl     plist                                                  CSW025
228800210720     C                   parm                    q@DQNameIn       10            CSW025
228900210720     C                   parm      '*LIBL'       q@DQLibl                       CSW025
229000210720     C                   parm      12000         q@DQLength                     CSW025
229100210720     C                   parm                    q@DQData                       CSW025
229200210720     C                   parm      1200          q@DQwait          5 0
229300210720     C                   parm      'EQ'          q@korder          2                          CSW034
229400210720     C                   parm      2             q@klength         3 0                        CSW034
229500210720     C                   parm                    q@rkey            2                          CSW034
229600210720     C                   parm                    q@sndlen          3 0                        CSW034
229700210720     C                   parm                    q@sndinfo        45                          CSW034
229800210720      *
229900210720      ** Access SDSTAT for system prefix
230000210720     C                   in        sdstat
230100210720     C                   movel     LIBR          q@skey                                       244430
230200210720     C/COPY WNCPYSRC,MS6110MC05
230300210720      *
230400210720      ** Access bank details
230500210720     C                   call      'AOBANKR0'
230600210720     C                   parm      *blanks       p@rtcd            7
230700210720     C                   parm      '*FIRST'      p@optn            7
230800210720     C     sdbank        parm      *blanks       dsfdy
230900210720      *
231000210720      ** If the Access Object returns an error code, database error
231100210720     C     p@rtcd        ifne      *blank
231200210720     C                   movel     'AOBANKR0'    w0file
231300210720     C                   movel     'bank details'w0key
231400210720     C                   z-add     02            w0ernb
231500210720     C                   movel     'MEM5003'     w0msgd
231600210720     C                   movel     'MIDAS  '     w0msgf
231700210720     C                   exsr      srerr
231800210720     C                   endif
231900210720                                                                                CSW025
232000210720      ** Check if the Data Queue export feature is present.                     CSW025
232100210720      **  If not, export is via an MQSeries queue.                              CSW025
232200210720     C                   CALLB     'AOSARDR0'                                   CSW025
232300210720     C                   PARM      *BLANKS       @RTCD                          CSW025
232400210720     C                   PARM      '*VERIFY'     @OPTN                          CSW025
232500210720     C                   PARM      'CSW025'      @SARD                          CSW025
232600210720     C     SCSARD        PARM      SCSARD        DSFDY                          CSW025
232700210720     C     @RTCD         IFEQ      *BLANKS                                      CSW025
232800210720     C                   MOVE      'Y'           CSW025            1            CSW025
232900210720     C                   ELSE                                                   CSW025
233000210720     C                   MOVE      'N'           CSW025                         CSW025
233100210720     C                   ENDIF                                                  CSW025
233200210720      *
233300210720      ** ... or not quite: if MMM (CSW025) is on, we check for CSW038;          CSW038
233400210720      ** if THAT is on we use MQSeries; but if it is off we use data            CSW038
233500210720      ** queues.                                                                CSW038
233600210720     C                   CALLB     'AOSARDR0'                                   CSW038
233700210720     C                   PARM      *BLANKS       @RTCD                          CSW038
233800210720     C                   PARM      '*VERIFY'     @OPTN                          CSW038
233900210720     C                   PARM      'CSW038'      @SARD                          CSW038
234000210720     C     SCSARD        PARM      SCSARD        DSFDY                          CSW038
234100210720     C     @RTCD         IFEQ      *BLANKS                                      CSW038
234200210720     C                   MOVE      'Y'           CSW038            1            CSW038
234300210720     C                   ELSE                                                   CSW038
234400210720     C                   MOVE      'N'           CSW038                         CSW038
234500210720     C                   ENDIF                                                  CSW038
234600210720
234700210720     C                   CALLB     'AOSARDR0'                                   CSW034
234800210720     C                   PARM      *BLANKS       @RTCD                          CSW034
234900210720     C                   PARM      '*VERIFY'     @OPTN                          CSW034
235000210720     C                   PARM      'CSW034'      @SARD                          CSW034
235100210720     C     SCSARD        PARM      SCSARD        DSFDY                          CSW034
235200210720     C     @RTCD         IFEQ      *BLANKS                                      CSW034
235300210720     C                   MOVE      'Y'           CSW034            1            CSW034
235400210720     C                   ELSE                                                   CSW034
235500210720     C                   MOVE      'N'           CSW034                         CSW034
235600210720     C                   ENDIF                                                  CSW034
235700210720      *                                                                                       CSW209
235800210720      ** Check if SWIFT2009 is installed                                                      CSW209
235900210720      *                                                                                       CSW209
236000210720     C                   call      'SWIF2009'                                                 CSW209
236100210720     C                   parm                    p@rtcd                                       CSW209
236200210720      *                                                                                       CSW209
236300210720     C     p@rtcd        ifeq      'CSW2009'                                                  CSW209
236400210720     C                   eval      csw209 = 'Y'                                               CSW209
236500210720     C                   else                                                                 CSW209
236600210720     C                   eval      csw209 = 'N'                                               CSW209
236700210720     C                   endif                                                                CSW209
236800210720      *
236900210720      ** Proceessing for *INCOMING mode
237000210720     C     p@io          ifeq      'I'
237100210720      *
237200210720     C/COPY WNCPYSRC,MS6110MC19
237300210720      ** Build arrays of SWIFT BIC+branch details v Midas branch code for
237400210720      ** use when assigning Midas branch to incoming messages (in sr_ix).
237500210720     C                   z-add     1             w@b               5 0
237600210720     C     *loval        setll     sdbrchl0
237700210720     C                   read      sdbrchl0                               50
237800210720     C     *in50         doweq     *off
237900210720     C*****w@b**         andle     99                                                         252317
238000210720     C     w@b           andle     999                                                        252317
238100210720     C                   movel     A8BRCD        br@midas(w@b)
238200210720     C                   movel(p)  w@brad        br@swift(w@b)
238300210720     C                   move      w@brbr        br@swift(w@b)
238400210720      ** Set default branch to be that of bank's internal customer                            252317
238500210720     C                   if        BJCUST = A8BICN                                            252317
238600210720     C                   movel     A8BRCD        dftbrch           3                          252317
238700210720     C                   end                                                                  252317
238800210720     C                   read      sdbrchl0                               50
238900210720     C                   add       1             w@b
239000210720     C                   enddo
239100210720     C/COPY WNCPYSRC,MS6110MC20
239200210720      *
239300210720      ** Get module details (to check for AutoRecs II)
239400210720     C                   call      'AOMMODR0'
239500210720     C                   parm      *blanks       p@rtcd            7
239600210720     C                   parm      '*FIRST'      p@optn            7
239700210720     C     sdmmod        parm      *blanks       dsfdy
239800210720      *
239900210720      ** If the Access Object returns an error code, database error
240000210720     C     p@rtcd        ifne      *blank
240100210720     C                   movel     'AOMMODR0'    w0file
240200210720     C                   movel(p)  'modules'     w0key
240300210720     C                   z-add     03            w0ernb
240400210720     C                   movel     'MEM5003'     w0msgd
240500210720     C                   movel     'MIDAS  '     w0msgf
240600210720     C                   exsr      srerr
240700210720     C                   endif
240800210720     C
240900210720     C                   endif
241000210720      *
241100210720      ** Get communication details from file
241200210720     C     p@mcid        chain(n)  MSMCIDL0                           51
241300210720     c     *in51         ifeq      *on
241400210720     C                   movel     'MSMCIDL0'    w0file
241500210720     C                   movel     p@mcid        w0key
241600210720     C                   z-add     04            w0ernb
241700210720     C                   movel     'MEM5003'     w0msgd
241800210720     C                   movel     'MIDAS  '     w0msgf
241900210720     C                   exsr      srerr
242000210720     C                   endif
242100210720
242200210720      ** Determine API Header record lengths
242300210720
242400210720     C                   CALLB     'UTGETRCDLN'
242500210720
242600210720      ** Return code
242700210720     C                   PARM                    ReturnCode       10
242800210720      ** Record length
242900210720     C                   PARM      *ZERO         HLEN              5 0
243000210720      ** File name
243100210720     C/COPY WNCPYSRC,MS6110MC06
243200210720     C                   PARM      'APHEADPD  '  FileName         10
243300210720     C/COPY WNCPYSRC,MS6110MC07
243400210720      ** File library
243500210720     C                   PARM      '*LIBL     '  FileLib          10
243600210720
243700210720     C/COPY WNCPYSRC,MS6110MC08
243800210720     C                   ADD       1             HLEN
243900210720     C/COPY WNCPYSRC,MS6110MC09
244000210720      *
244100210720      ***If*CSW038*is*on*(we*are*sending*message*to*MMM*via*MQSeries)**                CSW038 250527
244200210720      ***then*we*need*the*length*of*the*Meridian*1.7*header*instead****                CSW038 250527
244300210720     C                   if        CSW038 = 'Y'                                               CSW038
244400210720                                                                                              CSW038
244500210720     C**********         CALLB     'UTGETRCDLN'                                        CSW028 250527
244600210720      ***Return*code***************************************************                CSW028 250527
244700210720     C**********         PARM                    ReturnCode       10                   CSW028 250527
244800210720      ** Record length*************************************************                CSW028 250527
244900210720     C**********         PARM      *ZERO         HLEN                                  CSW028 250527
245000210720      ** File name*****************************************************                CSW028 250527
245100210720     C**********         PARM      'APMH17PD  '  FileName         10                   CSW028 250527
245200210720      ** File library                                                                  CSW038 250527
245300210720     C**********         PARM      '*LIBL     '  FileLib          10                   CSW038 250527
245400210720                                                                                              CSW038
245500210720     C**********         ADD       1             HLEN                                  CSW038 250527
245600210720     C                   Z-ADD     1             HLEN                                         250527
245700210720     C                   endif                                                                CSW038
245800210720
245900210720      ** Initialise failure flag, termination indicator, 'open'
246000210720      ** and 'server termination requested' flags
246100210720      ** also MQ open error flag as 'open' flag was used for two reasons        CSW025
246200210720     C                   movel     'N'           w@abnormal        1
246300210720     C                   movel     *off          *in01
246400210720     C                   movel     'N'           w@connect         1                          245310
246500210720     C                   movel     'N'           w@open            1
246600210720     C                   movel     'N'           w@srvr_trq        1
246700210720     C                   movel     'N'           w@MQConnErr       1                          245310
246800210720     C                   movel     'N'           w@MQOpenErr       1            CSW025
246900210720
247000210720      ** Use default connection handle, and implicit connection
247100210720     C                   Z-ADD     HCDEFH        HCONN
247200210720
247300210720      *                                                                                     MD051624
247400210720      ** Get Machine Date for TRAN value                                                    MD051624
247500210720      *                                                                                     MD051624
247600210720     C                   CALLB     'AOSVALR0'                                               MD051624
247700210720     C                   PARM      *BLANKS       PRTCD                                      MD051624
247800210720     C                   PARM      MachineDate   PSysVal01                                  MD051624
247900210720     C                   PARM                    PCurSet01                                  MD051624
248000210720     C                   PARM                    PSysVal02                                  MD051624
248100210720     C                   PARM                    PCurSet02                                  MD051624
248200210720     C                   PARM                    PSysVal03                                  MD051624
248300210720     C                   PARM                    PCurSet03                                  MD051624
248400210720     C                   PARM                    PSysVal04                                  MD051624
248500210720     C                   PARM                    PCurSet04                                  MD051624
248600210720     C                   PARM                    PSysVal05                                  MD051624
248700210720     C                   PARM                    PCurSet05                                  MD051624
248800210720     C                   PARM                    PSysVal06                                  MD051624
248900210720     C                   PARM                    PCurSet06                                  MD051624
249000210720     C                   PARM                    PSysVal07                                  MD051624
249100210720     C                   PARM                    PCurSet07                                  MD051624
249200210720     C                   PARM                    PSysVal08                                  MD051624
249300210720     C                   PARM                    PCurSet08                                  MD051624
249400210720     C                   PARM                    PSysVal09                                  MD051624
249500210720     C                   PARM                    PCurSet09                                  MD051624
249600210720     C                   PARM                    PSysVal10                                  MD051624
249700210720     C                   PARM                    PCurSet10                                  MD051624
249800210720      *                                                                                     MD051624
249900210720     C     PRTCD         IFEQ      *BLANKS                                                  MD051624
250000210720     C                   MOVEL     PCurSet01     WMACFLAG                                   MD051624
250100210720     C                   ENDIF                                                              MD051624
250200210720      ** Open MQ series queue
250300210720      **  only if the Data Queue export feature is not present.                 CSW025
250400210720     C                   if        CSW025 = 'N'                                 CSW025
250500210720     C                               OR CSW038 = 'Y'                            CSW038
250600210720      ** Access System Value                                                                MD048231
250700210720     C                                                                                      MD048231
250800210720     C                   EVAL      PSysVal02 = 'AllowPaperSendToMMM'                        MD048231
250900210720      ** If a Queue Manager is specified on SYSTEM VALUE MQQueueManager then                  245310
251000210720      ** connect to it and retain connection handle for other QMQM calls                      245310
251100210720      ** instead of using the default Queue Manager and connection                            245310
251200210720                                                                                              245310
251300210720     C                   CALLB     'AOSVALR0'                                                 245310
251400210720     C                   PARM      *BLANKS       PRtCd             7                          245310
251500210720     C                   PARM      MQManager     PSysVal01                                    245310
251600210720     C                   PARM                    PCurSet01                                    245310
251700210720     C                   PARM                    PSysVal02                                    245310
251800210720     C                   PARM                    PCurSet02                                    245310
251900210720     C                   PARM                    PSysVal03                                    245310
252000210720     C                   PARM                    PCurSet03                                    245310
252100210720     C                   PARM                    PSysVal04                                    245310
252200210720     C                   PARM                    PCurSet04                                    245310
252300210720     C                   PARM                    PSysVal05                                    245310
252400210720     C                   PARM                    PCurSet05                                    245310
252500210720     C                   PARM                    PSysVal06                                    245310
252600210720     C                   PARM                    PCurSet06                                    245310
252700210720     C                   PARM                    PSysVal07                                    245310
252800210720     C                   PARM                    PCurSet07                                    245310
252900210720     C                   PARM                    PSysVal08                                    245310
253000210720     C                   PARM                    PCurSet08                                    245310
253100210720     C                   PARM                    PSysVal09                                    245310
253200210720     C                   PARM                    PCurSet09                                    245310
253300210720     C                   PARM                    PSysVal10                                    245310
253400210720     C                   PARM                    PCurSet10                                    245310
253500210720                                                                                              245310
253600210720     C     PRtCd         IFNE      *BLANKS                                                    245310
253700210720     C                   MOVEL     PCurSet01     QMGR             48                          245310
253800210720     C                   exsr      sr_connect                                                 245310
253900210720     C                   z-add     HANDLE        HCONN                                        245310
254000210720     C                   endif                                                                245310
254100210720     C                   MOVEL     PCurSet02     MMMPaper                                   MD048231
254200210720     C                   exsr      sr_open
254300210720      **                                                                                    MD048231
254400210720      ** If CSW025 = 'Y' and CSW038 = 'N', Get system value for PAPER processing            MD048231
254500210720      **                                                                                    MD048231
254600210720     C                   ELSE                                                               MD048231
254700210720     C                   EVAL      PSysVal01 = 'AllowPaperSendToMMM'                        MD048231
254800210720     C                   CALLB     'AOSVALR0'                                               MD048231
254900210720     C                   PARM      *BLANKS       PRtCd             7                        MD048231
255000210720     C                   PARM                    PSysVal01                                  MD048231
255100210720     C                   PARM                    PCurSet01                                  MD048231
255200210720     C                   PARM                    PSysVal02                                  MD048231
255300210720     C                   PARM                    PCurSet02                                  MD048231
255400210720     C                   PARM                    PSysVal03                                  MD048231
255500210720     C                   PARM                    PCurSet03                                  MD048231
255600210720     C                   PARM                    PSysVal04                                  MD048231
255700210720     C                   PARM                    PCurSet04                                  MD048231
255800210720     C                   PARM                    PSysVal05                                  MD048231
255900210720     C                   PARM                    PCurSet05                                  MD048231
256000210720     C                   PARM                    PSysVal06                                  MD048231
256100210720     C                   PARM                    PCurSet06                                  MD048231
256200210720     C                   PARM                    PSysVal07                                  MD048231
256300210720     C                   PARM                    PCurSet07                                  MD048231
256400210720     C                   PARM                    PSysVal08                                  MD048231
256500210720     C                   PARM                    PCurSet08                                  MD048231
256600210720     C                   PARM                    PSysVal09                                  MD048231
256700210720     C                   PARM                    PCurSet09                                  MD048231
256800210720     C                   PARM                    PSysVal10                                  MD048231
256900210720     C                   PARM                    PCurSet10                                  MD048231
257000210720                                                                                            MD048231
257100210720     C                   IF        PrtCd = *BLANKS                                          MD048231
257200210720     C                   MOVEL     PCurSet01     MMMPaper                                   MD048231
257300210720     C                   ENDIF                                                              MD048231
257400210720     C                   endif                                                  CSW025
257500210720                                                                                CSW025
257600210720      ** If the Data Queue export feature is present:                           CSW025
257700210720     C                   if        CSW025 = 'Y'                                 CSW025
257800210720                                                                                CSW025
257900210720      **  - set up the 10A in the PLISTs from the 50A D/B field                 CSW025
258000210720     C                   if        p@io = 'I'                                   CSW025
258100210720     C                   movel     MCMQQN        q@DQNameIn                     CSW025
258200210720     C                   else                                                   CSW025
258300210720     C                   movel     MCMQQN        q@DQNameOut                    CSW025
258400210720     C                   endif                                                  CSW025
258500210720                                                                                CSW025
258600210720     C                   endif                                                  CSW025
258700210720                                                                                              CTI004
258800210720     C                   CALL      'AOSARDR0'                                                 CTI004
258900210720     C                   PARM      *BLANKS       PRTCD                                        CTI004
259000210720     C                   PARM      '*VERIFY'     POPTN                                        CTI004
259100210720     C                   PARM      'CTI004'      PSARD                                        CTI004
259200210720     C     SCSARD        PARM      SCSARD        DSFDY                                        CTI004
259300210720                                                                                              CTI004
259400210720     C                   IF        PRTCD = *BLANKS                                            CTI004
259500210720     C                   EVAL      CTI004 = 'Y'                                               CTI004
259600210720     C                   ELSE                                                                 CTI004
259700210720     C                   EVAL      CTI004 = 'N'                                               CTI004
259800210720     C                   ENDIF                                                                CTI004
259900210720      *
260000210720     C**********         movel     MCSYTM        wk10             10                  CSW034 BUG3189
260100210720     C*****wk10*         chain     HOSTSYSTL2                                         CSW034 BUG3189
260200210720     C                   If        CSW038 = 'N'                                             BUG12318
260300210720     C                   Call      'RTVNODEREF'                                              BUG3189
260400210720     C                   Parm      MCSYTM        HostID            2                         BUG3189
260500210720     C                   Parm                    noderef           2 0                       BUG3189
260600210720      *                                                                                      BUG3189
260700210720     C                   movel     noderef       q@skey                                       CSW034
260800210720     C**********         move      10            q@skey                               CSW034 BUG3189
260900210720      *                                                                                       CSW034
261000210720     C                   move      MCSYTM        q@rkey                                       CSW034
261100210720     C                   EndIf                                                              BUG12318
261200210720      *
261300210720      ** Pop subroutine
261400210720     C                   clear                   @STK(Q)
261500210720     C                   sub       1             Q
261600210720     C                   endsr
261700210720      /EJECT                                                                                  245310
261800210720      **********************************************************************                  245310
261900210720      * sr_connect     : Connect to Queue Manager                          *                  245310
262000210720      * ----------                                                         *                  245310
262100210720      *                                                                    *                  245310
262200210720      * Called by      : sr_init                                           *                  245310
262300210720      *                                                                    *                  245310
262400210720      * Calls          : QMQM                                              *                  245310
262500210720      *                                                                    *                  245310
262600210720      **********************************************************************                  245310
262700210720      *                                                                                       245310
262800210720     C     sr_connect    begsr                                                                245310
262900210720      *                                                                                       245310
263000210720      ** Push subroutine                                                                      245310
263100210720     C                   add       1             Q                                            245310
263200210720     C                   movel     'sr_connect'  @STK(Q)                                      245310
263300210720                                                                                              245310
263400210720      ** Connect to queue manager                                                             245310
263500210720                                                                                              245310
263600210720     C**********         CALL      'QMQM'                                            245310 MD041126
263700210720     C**********         PARM      MQCONN        CID               9 0               245310 MD041126
263800210720     C**********         PARM      QMGR          QMNAME           48                 245310 MD041126
263900210720     C**********         PARM      *ZERO         HANDLE            9 0               245310 MD041126
264000210720     C**********         PARM      *ZERO         OCODE             9 0               245310 MD041126
264100210720     C**********         PARM      *ZERO         REASON            9 0               245310 MD041126
264200210720                                                                                            MD041126
264300210720     C                   EVAL      QMNAME = QMGR                                            MD041126
264400210720     C                   Z-ADD     *ZERO         HANDLE                                     MD041126
264500210720     C                   Z-ADD     *ZERO         OCODE                                      MD041126
264600210720     C                   Z-ADD     *ZERO         REASON                                     MD041126
264700210720     C                   CALLP     MQCONN( QMNAME : HANDLE :                                MD041126
264800210720     C                                     OCODE : REASON )                                 MD041126
264900210720      *                                                                                       245310
265000210720      ** Trace                                                                                245310
265100210720     C                   movel     '*CONN  '     PR@FN                                        245310
265200210720     C                   exsr      sr_trace                                                   245310
265300210720                                                                                              245310
265400210720      ** If connection failed, indicate abnormal end                                          245310
265500210720                                                                                              245310
265600210720     C     REASON        IFNE      RCNONE                                                     245310
265700210720     C     REASON        andne     RC2002                                                     245310
265800210720     C                   movel     'Y'           w@abnormal                                   245310
265900210720     C                   movel     'QMQM     '   w0file                                       245310
266000210720     C                   movel     'MEM6001'     w0msgd                                       245310
266100210720     C                   movel     'MIDAS  '     w0msgf                                       245310
266200210720     C                   movel     'Connect   '  w0key                                        245310
266300210720     C                   movel     REASON        w0reas                                       245310
266400210720     C                   z-add     105           w0ernb                                       245310
266500210720     C                   movel     'Y'           W@MQConnErr                                  245310
266600210720                                                                                              245310
266700210720      ** If no failure, identify successful connect                                           245310
266800210720                                                                                              245310
266900210720     C                   else                                                                 245310
267000210720     C                   movel     'Y'           w@connect                                    245310
267100210720     C                   endif                                                                245310
267200210720      *                                                                                       245310
267300210720      ** Pop subroutine                                                                       245310
267400210720     C                   clear                   @STK(Q)                                      245310
267500210720     C                   sub       1             Q                                            245310
267600210720     C                   endsr                                                                245310
267700210720      /EJECT
267800210720      **********************************************************************
267900210720      * sr_open        : Open MQ series queue                              *
268000210720      * -------                                                            *
268100210720      *                                                                    *
268200210720      * Called by      : sr_init                                           *
268300210720      *                                                                    *
268400210720      * Calls          : QMQM                                              *
268500210720      *                                                                    *
268600210720      **********************************************************************
268700210720      *
268800210720     C     sr_open       begsr
268900210720      *
269000210720      ** Push subroutine
269100210720     C                   add       1             Q
269200210720     C                   movel     'sr_open'     @STK(Q)
269300210720     C/COPY WNCPYSRC,MS6110MC16
269400210720
269500210720      ** Queue manager name                                                     CSW038
269600210720     C     MCMQMN        ifne      *Blank                                       CSW038
269700210720     C                   MOVEL     MCMQMN        ODMN             48            CSW038
269800210720     C                   endif                                                  CSW038
269900210720                                                                                CSW038
270000210720      ** Connect to the queue manager; we have to do this explicitly            CSW038
270100210720      ** now, in order to support non-default queue managers.                   CSW038
270200210720     C**********         Z-ADD     MQCONN        CID                                 CSW038 MD041126
270300210720     C**********         CALL      'QMQM'                                            CSW038 MD041126
270400210720     C**********         PARM                    CID               9 0               CSW038 MD041126
270500210720     C**********         PARM                    MCMQMN                              CSW038 MD041126
270600210720     C**********         PARM                    HCONN             9 0               CSW038 MD041126
270700210720     C**********         PARM                    OCODE             9 0               CSW038 MD041126
270800210720     C**********         PARM                    REASON            9 0               CSW038 MD041126
270900210720                                                                                            MD041126
271000210720     C                   CALLP     MQCONN( MCMQMN : HCONN :                                 MD041126
271100210720     C                                     OCODE : REASON )                                 MD041126
271200210720                                                                                CSW038
271300210720      ** If connect failed, indicate abnormal end                               CSW038
271400210720                                                                                CSW038
271500210720     C     REASON        IFNE      RCNONE                                       CSW038
271600210720     C                   movel     'Y'           w@abnormal                     CSW038
271700210720     C                   movel     'QMQM     '   w0file                         CSW038
271800210720     C                   movel     'MEM6001'     w0msgd                         CSW038
271900210720     C                   movel     'MIDAS  '     w0msgf                         CSW038
272000210720     C                   movel     'Conn Mgr  '  w0key                          CSW038
272100210720     C                   movel     REASON        w0reas                         CSW038
272200210720     C                   z-add     103           w0ernb                         CSW038
272300210720     C                   movel     'Y'           W@MQOpenErr                    CSW038
272400210720     C                   exsr      sr_term                                      CSW038
272500210720     C                   endif                                                  CSW038
272600210720                                                                                CSW038
272700210720      ** Queue name
272800210720     C                   MOVEL     MCMQQN        ODON             48
272900210720
273000210720      ** Open queue for INPUT
273100210720
273200210720     C     p@io          ifeq      'I'
273300210720
273400210720      ** Open options: INPUT and FAIL_IF_QUIESCING
273500210720     C     OOINPQ        ADD       OOFIQ         OPTS
273600210720
273700210720      ** Open queue for OUTPUT
273800210720
273900210720     C                   else
274000210720
274100210720      ** Open options: OUTPUT and FAIL_IF_QUIESCING
274200210720     C     OOOUT         ADD       OOFIQ         OPTS
274300210720     C                   endif
274400210720                                                                                              242607
274500210720      ** Clear Q-Manager so it can use clustered queues / remote Q-manager as well            242607
274600210720     C                   MOVE      *BLANKS       ODMN                                         242607
274700210720
274800210720      ** Open queue
274900210720     C**********         Z-ADD     MQOPEN        CID                                        MD041126
275000210720     C**********         CALL      'QMQM'                                                   MD041126
275100210720     C**********         PARM                    CID               9 0                      MD041126
275200210720     C**********         PARM                    HCONN             9 0                      MD041126
275300210720     C**********         PARM                    MQOD                                       MD041126
275400210720     C**********         PARM                    OPTS              9 0                      MD041126
275500210720     C**********         PARM                    HIN               9 0                      MD041126
275600210720     C**********         PARM                    OCODE             9 0                      MD041126
275700210720     C**********         PARM                    REASON            9 0                      MD041126
275800210720                                                                                            MD041126
275900210720     C                   CALLP     MQOPEN( HCONN : MQOD : OPTS :                            MD041126
276000210720     C                                     HIN : OCODE : REASON )                           MD041126
276100210720      *
276200210720      ** Trace
276300210720     C                   movel     '*OPEN  '     PR@FN
276400210720     C                   exsr      sr_trace
276500210720
276600210720      ** If open queue failed, indicate abnormal end
276700210720
276800210720     C     REASON        IFNE      RCNONE
276900210720     C                   movel     'Y'           w@abnormal
277000210720     C                   movel     'QMQM     '   w0file
277100210720     C                   movel     'MEM6001'     w0msgd
277200210720     C                   movel     'MIDAS  '     w0msgf
277300210720     C                   movel     'Open queue'  w0key
277400210720     C                   movel     REASON        w0reas
277500210720     C                   z-add     103           w0ernb
277600210720     C                   movel     'Y'           W@MQOpenErr                    CSW025
277700210720
277800210720      ** If no failure, identify successful open
277900210720
278000210720     C                   else
278100210720     C                   movel     'Y'           w@open
278200210720     C                   endif
278300210720     C/COPY WNCPYSRC,MS6110MC17
278400210720      *
278500210720      ** Pop subroutine
278600210720     C                   clear                   @STK(Q)
278700210720     C                   sub       1             Q
278800210720     C                   endsr
278900210720      /EJECT
279000210720      **********************************************************************
279100210720      * sr_close       : Close MQ series queue                             *
279200210720      * --------                                                           *
279300210720      *                                                                    *
279400210720      * Called by      : sr_term                                           *
279500210720      *                                                                    *
279600210720      * Calls          : QMQM                                              *
279700210720      *                                                                    *
279800210720      **********************************************************************
279900210720      *
280000210720     C     sr_close      begsr
280100210720      *
280200210720      ** Push subroutine
280300210720     C                   add       1             Q
280400210720     C                   movel     'sr_close'    @STK(Q)
280500210720
280600210720      ** Close options: NONE
280700210720     C                   Z-ADD     CONONE        OPTS
280800210720
280900210720      ** Close queue
281000210720     C**********         Z-ADD     MQCLOS        CID                                        MD041126
281100210720     C**********         CALL      'QMQM'                                                   MD041126
281200210720     C**********         PARM                    CID               9 0                      MD041126
281300210720     C**********         PARM                    HCONN             9 0                      MD041126
281400210720     C**********         PARM                    HIN               9 0                      MD041126
281500210720     C**********         PARM                    OPTS              9 0                      MD041126
281600210720     C**********         PARM                    CCODE             9 0                      MD041126
281700210720     C**********         PARM                    REASON            9 0                      MD041126
281800210720                                                                                            MD041126
281900210720     C                   CALLP     MQCLOSE( HCONN : HIN : OPTS :                            MD041126
282000210720     C                                      CCODE : REASON )                                MD041126
282100210720      *
282200210720      ** Trace
282300210720     C                   movel     '*CLOSE '     PR@FN
282400210720     C                   exsr      sr_trace
282500210720
282600210720      ** If close queue failed, indicate abnormal end
282700210720
282800210720     C     REASON        IFNE      RCNONE
282900210720     C                   movel     'Y'           w@abnormal
283000210720     C                   movel     'QMQM     '   w0file
283100210720     C                   movel     'MEM6001'     w0msgd
283200210720     C                   movel     'MIDAS  '     w0msgf
283300210720     C                   movel     'Close queue' w0key
283400210720     C                   movel     REASON        w0reas
283500210720     C                   z-add     104           w0ernb
283600210720     C                   endif
283700210720     C/COPY WNCPYSRC,MS6110MC18
283800210720      *
283900210720      ** Pop subroutine
284000210720     C                   clear                   @STK(Q)
284100210720     C                   sub       1             Q
284200210720     C                   endsr
284300210720      /EJECT                                                                                  245310
284400210720      **********************************************************************                  245310
284500210720      * sr_disconn     : Disconnect from Queue Manager                     *                  245310
284600210720      * ----------                                                         *                  245310
284700210720      *                                                                    *                  245310
284800210720      * Called by      : sr_term                                           *                  245310
284900210720      *                                                                    *                  245310
285000210720      * Calls          : QMQM                                              *                  245310
285100210720      *                                                                    *                  245310
285200210720      **********************************************************************                  245310
285300210720      *                                                                                       245310
285400210720     C     sr_disconn    begsr                                                                245310
285500210720      *                                                                                       245310
285600210720      ** Push subroutine                                                                      245310
285700210720     C                   add       1             Q                                            245310
285800210720     C                   movel     'sr_disconn'  @STK(Q)                                      245310
285900210720                                                                                              245310
286000210720      ** Disconnect from Queue Manager                                                        245310
286100210720                                                                                              245310
286200210720     C**********         CALL      'QMQM'                                            245310 MD041126
286300210720     C**********         PARM      MQDISC        CID               9 0               245310 MD041126
286400210720     C**********         PARM                    HCONN             9 0               245310 MD041126
286500210720     C**********         PARM      *ZERO         OCODE             9 0               245310 MD041126
286600210720     C**********         PARM      *ZERO         REASON            9 0               245310 MD041126
286700210720                                                                                            MD041126
286800210720     C                   Z-ADD     *ZERO         OCODE                                      MD041126
286900210720     C                   Z-ADD     *ZERO         REASON                                     MD041126
287000210720     C                   CALLP     MQDISC( HCONN : OCODE : REASON )                         MD041126
287100210720      *                                                                                       245310
287200210720      ** Trace                                                                                245310
287300210720     C                   movel     '*DISC  '     PR@FN                                        245310
287400210720     C                   exsr      sr_trace                                                   245310
287500210720                                                                                              245310
287600210720      ** If connection failed, indicate abnormal end                                          245310
287700210720                                                                                              245310
287800210720     C     REASON        IFNE      RCNONE                                                     245310
287900210720     C                   movel     'Y'           w@abnormal                                   245310
288000210720     C                   movel     'QMQM     '   w0file                                       245310
288100210720     C                   movel     'MEM6001'     w0msgd                                       245310
288200210720     C                   movel     'MIDAS  '     w0msgf                                       245310
288300210720     C                   movel     'Disconnect'  w0key                                        245310
288400210720     C                   movel     REASON        w0reas                                       245310
288500210720     C                   z-add     106           w0ernb                                       245310
288600210720     C                   endif                                                                245310
288700210720      *                                                                                       245310
288800210720      ** Pop subroutine                                                                       245310
288900210720     C                   clear                   @STK(Q)                                      245310
289000210720     C                   sub       1             Q                                            245310
289100210720     C                   endsr                                                                245310
289200210720      /EJECT
289300210720      *****************************************************************
289400210720      *                                                               *
289500210720      * *PSSR  - Program exception error routine                      *
289600210720      *          Called automatically if a program error occurs,      *
289700210720      *          or directly by the program code using EXSR.          *
289800210720      *          This subroutine DUMPs the program just once.         *
289900210720      *                                                               *
290000210720      * Called by: (**calling routines**)                             *
290100210720      *                                                               *
290200210720      * Calls: None                                                   *
290300210720      *                                                               *
290400210720      *****************************************************************
290500210720      *
290600210720     C     *PSSR         begsr
290700210720      *
290800210720     C     @run          ifeq      *blank
290900210720     C                   move      'Y'           @run              1
291000210720      *
291100210720      ** Shutdown compression server for transmission jobs if not
291200210720      ** already requested
291300210720     C     p@io          ifeq      'O'
291400210720     C     w@srvr_trq    andeq     'N'
291500210720     C                   movel(p)  '*SHUTDOWN'   q@prompt
291600210720     C                   call      'QSNDDTAQ'    q@snddtaq
291700210720     C                   movel     'Y'           w@srvr_trq
291800210720     C                   endif
291900210720      *
292000210720     C                   dump
292100210720      *
292200210720     C                   endif
292300210720      *
292400210720      ** Push subroutine
292500210720     C                   add       1             Q
292600210720     C                   movel     '*PSSR'       @STK(Q)
292700210720      *
292800210720     C                   seton                                        U7U8LR
292900210720     C                   return
293000210720     C                   endsr
293100210720      *
293200210720      ********************************************************************
293300210720     C*                                                                         184427
293400210720     C** tabtyp add MT340, MT341, MT360, MT361 and MT362.                       184427
293500210720     C** tabtyp add MT103                                                       CRE008
293600210720      /COPY MSCPYSRC,SRERRC
293700210720**CTDATA cpy@
293800210720(c) Finastra International Limited 2001
293900210720**CTDATA tabtyp
294000210720100A
294100210720103A
294200210720200A
294300210720201B
294400210720202A
294500210720203B
294600210720300A
294700210720320A
294800210720324A
294900210720330A
295000210720335A
295100210720350D
295200210720900A
295300210720910A
295400210720940C
295500210720950C
295600210720340A
295700210720341A
295800210720360A
295900210720361A
296000210720362A
296100210720370E                                                                                          CSW212
296200210720600A                                                                                          CSW212
296300210720**CTDATA tabmonn
29640021072001JAN
29650021072002FEB
29660021072003MAR
29670021072004APR
29680021072005MAY
29690021072006JUN
29700021072007JUL
29710021072008AUG
29720021072009SEP
29730021072010OCT
29740021072011NOV
29750021072012DEC
297600210720**CTDATA ar1
297700210720??4C<
297800210720??4F!
297900210720??50&
298000210720??5C*
298100210720??5E;
298200210720??6C%
298300210720??6D_
298400210720??6E>
298500210720??7B#
298600210720??7C@
298700210720??7E=
298800210720??7F"
298900210720??C0{
299000210720??D0}
299100210720**CTDATA tabty2                                                                               CSW212
299200210720370:19A::NETT                                                                                 CSW212
299300210720**CTDATA tabty3                                                                               CSW212
299400210720370:98A::VALU                                                                                 CSW212
