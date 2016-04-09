     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MS Midas/MMM compression server      *MODULE')
      *****************************************************************
      *                                                               *
      *  Midas SWIFT Direct link : Midas/MMM interface                *
      *                                                               *
      *  ME8200M - Midas/MMM compression server                       *
      *                                                               *
      *  Function:  This program formats outgoing SWIFT messages      *
      *             and passes them via a data queue to the           *
      *             transmission program.                             *
      *                                                               *
      *  Sbmtd by :                                                   *
      *                                                               *
      *  Calls    : QSNDDTAQ - Send data queue entry                  *
      *             QRCVDTAQ - Receive data queue entry               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 246533             Date 22Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 238594             Date 09Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG3189 *Reopen    Date 10Jun04               *
      *                 BUG3189            Date 09Jun04               *
      *                 CSW034             Date 09Jan04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 208771             Date 27Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW025 *CREATE     Date 26Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  246533 - If PAPER message do not expand destination as it may*
      *           not be a normal BIC and TRAM can't match it up.     *
      *  238594 - Generate exception report when message limit of     *
      *           10,000 has been reached.                            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3189- Reverse original changes for CSW034 and move it to  *
      *           MS6110M.                                            *
      *  BUG3189- Remove HOSTSYSTL2 and call RTVNODEREF instead.      *
      *  CSW034 - Midas Message Manager Global Processing             *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  208771 - Initialise message buffer                           *
      *  CSW025 - Midas Message Manager                               *
      *                                                               *
      *****************************************************************
      /EJECT
     FMGOREFL0  UF   E           K disk    infsr(srfile)
     FMGOREFL3  UF   E           K disk    infsr(srfile)
     F                                     rename(mgorefd0:mgorefd3)
     FMGOMSGPD  IF   E           K disk    infsr(srfile)
     F***MS8200AU**O****E******    printer infsr(srfile)                                      238594
     FME8200AU  O    E             printer infsr(srfile)                                      238594
     F                                     oflind(*in66)
     F                                     usropn
     FME8200P1  O    E             printer infsr(srfile)                                      238594
     F                                     oflind(*in67)                                      238594
     F                                     usropn                                             238594
     F***HOSTSYSTL2IF***E           K disk                                            CSW034 BUG3189
      /EJECT
      /COPY MSCPYSRC,SRERRD
      *
     D TAB1            S              5A   ctdata perrcd(1) dim(2)
      ** Table containing valid Block 3 Codes
      *
     D                 DS
     D  q@dqe                  1  12050
     D  q@sndref               1     50
     D**q@msgbuf**********    51  12050                                                       238594
     D********************                 DIM(12000)                                         238594
     D  q@msgbuf              51  13050                                                       238594
     D                                     DIM(13000)                                         238594
     D  q@prompt               1     50
     D  q@trace                1     50
      ** Data queue entry
      *
     D  msstat       E DS                  extname(MSSTAT)
     D  ZZ053N       E                     extfld(ZZ053)
      ** Midas/SWIFT Direct Link status data area
      *
      /SPACE 2
     D                 DS
     D  w@nwds                 1     20
     D  w@dbic                 1      8
     D  w@dbrch                9     11
      *
     D                 DS
     D  @REF1                  1    240
     D  SYTM                   1      6
     D  MODI                   7      8
     D  TRNO                   9     24
     D  TRNF                  25     40
     D  TRNM                  41     56
     D  MTRN                  57     71
     D  TNTP                  72     73
     D  SBTP                  74     75
     D  EVTP                  76     77
     D  NWRK                  78     83
     D**SECN****              84     89  0                                                    CSD027
     D  SECN                  84     89                                                       CSD027
     D  NWSN                  90    109
     D**DECN****             110    115  0                                                    CSD027
     D  DECN                 110    115                                                       CSD027
     D  NWDS                 116    135
     D  NWBN                 136    155
     D  @MTPY                156    158
     D  @MPRY                159    159
     D  MGSG                 160    160
     D  MGST                 161    164
     D  LSCC                 165    172
     D  F57U                 173    173
     D  PTST                 174    174
     D  CARQ                 175    175
     D  MPDE                 176    176
     D  HRDT                 177    182
     D  MGDE                 183    188  0
     D  MGTM                 189    194  0
     D  LADT                 195    201
     D  LATM                 202    207  0
     D  RELD                 208    214
     D  RELT                 215    220  0
     D  RUSR                 221    230
     D  RWSN                 231    240
     D                 DS
     D**@REF2***               1    175                                                       CGL029
     D  @REF2                  1    196                                                       CGL029
     D  AMTX                   1     17
     D  AMTS                  18     34
     D  SVDT                  35     40
     D  CCY                   41     43
     D  NSNO                  44     45  0
     D**SACN****              46     60                                                       CGL029
     D  SACNQQ                46     60                                                       CGL029
     D  AORR                  61     61
     D  DESI                  62     62
     D  BRCA                  63     65
     D  OTHB                  66     68
     D  RCBR                  69     71
     D  OTHT                  72     91
     D  NETI                  92     92
     D  DELC                  93     93
     D  DYST                  94     95
     D  RSID                  96    100
     D  MSE1                 101    103
     D  ELIN                 104    106
     D  SSAC                 107    109
     D  MIR                  110    137
     D  TSKS                 138    138
     D  TSKY                 139    153
     D  TSEQ                 154    158  0
     D  CFPF                 159    159
     D  @PT210               160    161  0
     D  @AVDT                162    166  0
     D  ASEQ                 167    169  0
     D  TODY                 170    170
     D  CIND                 171    171
     D  CINDV                172    172
     D  CLSS                 173    173
     D  SysPref              174    175
     D  SACN                 176    196                                                       CGL029
      **  MGOREFPD data structure
      *
     D                 DS
     D  @sw2                   1     49
     D  txt1                   1      6    INZ('{1:F01')
     D  @snd2                  7     18
     D  @tandt                14     14
     D  txt2                  19     33    INZ('9999999999}{2:I')
     D  MTPY                  34     36
     D  @dst2                 37     48
     D  MPRY                  49     49
      **  SWIFT II message header for outgoing message formatting
      *
      /SPACE 2
     D  w@txt4         S              4A   inz('}{3:')
      *
     D                 DS
     D  w@tx3                  1      4    inz('}{4:')
     D  w@cr                   5      5    inz(x'0d')
     D  w@lf                   6      6    inz(x'25')
     D  w@crlf                 5      6
     D  txt3                   1      6
     Dw@null           S              1    inz(x'00')
 
      ** Control codes and fixed texts
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      * Layout for the SDSTAT data area
 
     D dsfdy         E DS                  extname(DSFDY)                                     238594
      ** Data Structures used by access objects                                               238594
      *                                                                                       238594
     D sdbank        E DS                  extname(SDBANKPD)                                  238594
      ** Bank details data area                                                               238594
      *
      /EJECT
      *****************************************************************
      *  Index to Subroutines                                         *
      *                                                               *
      *  sr_init       : Initialise program and session               *                       238594
      *  sr_trace      : Trace function                               *
      *  sr_cmprs      : Compress message and send to data queue      *
      *  sr_format     : Format message for transmission              *
      *  sr_reset      : Reset status of pending message              *
      *  *PSSR         : Standard program exception error routine     *
      *****************************************************************
      /EJECT
 
      * Get the system prefix
     C                   in        SDSTAT
     C                   eval      SysPref = LIBR
 
      ** Define data areas
     C     *dtaara       define                  msstat
      *
      ** Parameter lists
     C     *entry        plist
     C                   parm                    p@dtqm           10
     C                   parm                    p@dtqc           10
      *
     C     q@rcvdtaq     plist
     C                   parm                    q@dtaq           10
     C                   parm      '*LIBL'       q@libl           10
     C                   parm                    q@length          5 0
     C                   parm                    q@dqe
     C                   parm                    q@wait            5 0
      *
     C     q@snddtaq     plist
     C                   parm      p@dtqm        q@dtaq
     C                   parm      '*LIBL'       q@libl
     C                   parm      12050         q@length
     C                   parm                    q@dqe
     C**********         parm      4             q@klength         3 0                CSW034 BUG3189
     C**********         parm                    q@key             4                  CSW034 BUG3189
      *
      ** Push routine
     C                   z-add     1             Q
     C                   movel     'mainline'    @STK(Q)
                                                                                              238594
      ** Perform initial process                                                              238594
     C                   exsr      sr_init                                                    238594
      *
      ** Wait for prompt
     C                   movel     p@dtqc        q@dtaq
     C                   z-add     -1            q@wait
     C                   z-add     50            q@length
     C                   call      'QRCVDTAQ'    q@rcvdtaq
      *
      ** DoWhile shutdown not requested
     C     q@prompt      downe     '*SHUTDOWN'
      *
      ** Get next message and send to data queue
     C                   exsr      sr_trace
     C                   exsr      sr_cmprs
     C                   exsr      sr_trace
      *
      ** Wait for prompt
     C                   movel     p@dtqc        q@dtaq
     C                   z-add     -1            q@wait
     C                   z-add     50            q@length
     C                   call      'QRCVDTAQ'    q@rcvdtaq
                                                                                              238594
      ** Close ME8200P1 report after reading xxxx records so that MS_M2M_SRV                  238594
      ** can be investigated for errors.                                                      238594
                                                                                              238594
     C     w@prtopnP1    ifeq      'Y'                                                        238594
     C     T#Count       andgt     100                                                        238594
     C                   z-add     0             T#Count                                      238594
     C                   movel     'N'           w@prtopnP1                                   238594
     C                   write     me8200d3                                                   238594
     C                   close     me8200p1                                                   238594
     C                   endif                                                                238594
     C                   add       1             T#Count                                      238594
     C                   enddo
      *
      ** Reset pending message if outstanding
     C                   exsr      sr_trace
     C                   exsr      sr_reset
     C                   exsr      sr_trace
      *
      ** Close printer file if open, and terminate
     C     w@prtopn      ifeq      'Y'
     C**********         write     ms8200f3                                                   238594
     C**********         close     ms8200au                                                   238594
     C                   write     me8200f3                                                   238594
     C                   close     me8200au                                                   238594
     C                   endif
                                                                                              238594
     C     w@prtopnP1    ifeq      'Y'                                                        238594
     C                   write     me8200d3                                                   238594
     C                   close     me8200p1                                                   238594
     C                   endif                                                                238594
      *
     C                   seton                                        LR
      /EJECT
      **********************************************************************
      * sr_trace       : Trace function                                    *
      * --------                                                           *
      *                                                                    *
      * Called by      : mainline                                          *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_trace      begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_trace'    @STK(Q)
      *
      ** Check whether trace requested. If it is, write trace information
      ** to report.
     C                   in        msstat
     C     TRACF         ifeq      'T'
      *
      ** If spool file not already open, open it now.
     C     w@prtopn      ifne      'Y'
     C                   movel     'Y'           w@prtopn          1
     C**********         open      ms8200au                                                   238594
     C**********         write     ms8200f1                                                   238594
     C                   open      me8200au                                                   238594
     C                   write     me8200f1                                                   238594
     C                   endif
      *
      ** Check for overflow and rewrite headings if necessary.
     C     *in66         ifeq      *on
     C                   movel     *off          *in66
     C**********         write     ms8200f1                                                   238594
     C                   write     me8200f1                                                   238594
     C                   endif
      *
      ** Set up standard details and write to report
     C                   time                    PR@TI
     C                   movel(p)  q@trace       PR@TR
     C**********         write     ms8200t1                                                   238594
     C                   write     me8200t1                                                   238594
     C     T#Exceed      ifeq      'Y'                                                        238594
     C                   write     me8200t2                                                   238594
     C                   endif                                                                238594
      *
     C                   endif
     C                   movel     'N'           T#Exceed                                     238594
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_cmprs       : Compress outgoing message and send to data queue  *
      * --------                                                           *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : QSNDDTAQ - Send data queue entry                  *
      *                                                                    *
      **********************************************************************
      *
     C     sr_cmprs      begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_cmprs'    @STK(Q)
      *
      ** Initialise 'message found' indication
     C                   movel     'N'           w@msgfnd          1
      *
      ** If specific message requested, access file and check it is
      ** flagged for recovery
     C     q@prompt      ifne      '*NEXT'
      *
     C                   movel     q@prompt      w@trn            16
     C     w@trn         chain     mgorefd0                           50
      *
     C     *in50         ifeq      *off
     C     MGST          ifeq      'RECO'
     C                   movel     'R'           w@msgfnd
     C                   else
     C                   unlock    mgorefl0
     C                   endif
     C                   endif
      *
      ** Else get next Ready-to-Send message
     C                   else
     C     *loval        setll     mgorefd3
     C                   read      mgorefd3                               50
      *
     C     *in50         ifeq      *off
     C                   movel     'Y'           w@msgfnd
     C                   endif
     C                   endif
      *
      ** If message found, format and set status to 'PEND' (Pending Tx)
     C     w@msgfnd      ifne      'N'
      *
     C                   clear                   q@msgbuf                                     208771
     C                   exsr      sr_format
     C     q@sndref      ifeq      '*ERROR'
     C                   movel     '4'           MGSG
     C                   movel     'EFMT'        MGST
     C                   else
     C                   movel     'PEND'        MGST
     C                   endif
      *
      ** Update appropriate format
     C     w@msgfnd      ifeq      'R'
     C                   update    mgorefd0
     C                   else
     C                   update    mgorefd3
     C                   endif
      *
      ** else (if no message found) set up '*NONE' for return
     C                   else
     C                   movel(p)  '*NONE'       q@sndref
     C                   endif
      *
      ***Set*dataq*key*************************************************               CSW034 BUG3189
     C*****mtpy*         ifeq      '940'                                              CSW034 BUG3189
     C*****mtpy*         oreq      '950'                                              CSW034 BUG3189
     C**********         move      '90'          q@key                                CSW034 BUG3189
     C**********         else                                                         CSW034 BUG3189
     C**********         move      '10'          q@key                                CSW034 BUG3189
     C**********         end                                                          CSW034 BUG3189
      *                                                                                       CSW034
     C*****LIBR*         chain     HOSTSYSTL2                                         CSW034 BUG3189
     C**********         Call      'RTVNODEREF'                                      BUG3189 BUG3189
     C**********         Parm      LIBR          HostID            2                 BUG3189 BUG3189
     C**********         Parm                    noderef           2 0               BUG3189 BUG3189
      **********                                                                     BUG3189 BUG3189
     C**********         movel     noderef       q@key                                CSW034 BUG3189
      *
      ** Send detail to data queue
     C                   call      'QSNDDTAQ'    q@snddtaq
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_format      : Format message for transmission                   *
      * ---------                                                          *
      *                                                                    *
      * Called by      : sr_out                                            *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_format     begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_format'   @STK(Q)
     C                   z-add     Q             Save_Q            5 0                        238594
     C                   z-add     12000         T#Limit           5 0                        238594
     C                   movel     'N'           T#Exceed          1                          238594
      *
      ** Access first data record which is not part-deleted
     C     TRNO          setll     mgomsgd0
     C     PTDL          doune     'D'
     C     *in15         oreq      *on
     C     TRNO          reade     mgomsgd0                               15
     C                   enddo
      *
      ** Database error if no live details found
     C     *in15         ifeq      *on
     C                   movel(p)  '*ERROR'      q@sndref
     C                   else
      *
      ** Expand destination address to 12 characters with 'X' between
      ** BIC and branch code, and branch code 'XXX' if not quoted.
      ** However if a PAPER message do not do this as it may not be                           246533
      ** a normal BIC (e.g. a customer number instead) so TRAM can't                          246533
      ** match it up                                                                          246533
      *                                                                                       246533
     C                   movel(p)  NWDS          w@nwds
     C     NWRK          ifne      'PAPER'                                                    246533
     C     w@dbrch       ifeq      *blanks
     C                   movel     'XXX'         w@dbrch
     C                   endif
     C                   movel(p)  w@dbic        @dst2
     C     @dst2         cat       'X':0         @dst2
     C     @dst2         cat       w@dbrch:0     @dst2
     C                   else                                                                 246533
     C                   movel(p)  w@dbic        @dst2                                        246533
     C                   endif                                                                246533
      *
      ** Set up sender's address and write SWIFT II header to message buffer
     C                   movel     NWSN          @snd2
     C                   movel     MTPY          @MTPY
     C                   movel     MPRY          @MPRY
     C                   z-add     PT210         @PT210
     C                   z-add     AVDT          @AVDT
      *
     C                   z-add     1             p                 5 0
     C                   movea     @ref1         q@msgbuf(p)
     C                   add       240           p
     C                   movea     @ref2         q@msgbuf(p)
     C**********         add       175           p                                            CGL029
     C                   add       196           p                                            CGL029
     C                   movea     @sw2          q@msgbuf(p)
     C                   add       49            p
      *
      ** Write delivery notification to message buffer if not blank,
      ** followed by end of block 2, start of block 4.
     C     DELC          ifne      '0'
     C     DELC          andne     ' '
     C                   movea     DELC          q@msgbuf(p)
     C                   add       1             p
     C                   endif
 
      ** Output all Block 3 details first before Block 4
 
     C     *in15         ifeq      *off
 
     C     MTAG          lookup    TAB1                                   17
 
     C     *in17         ifeq      *on
 
     C                   movea     w@txt4        q@msgbuf(p)
     C                   add       4             p
 
     C     *in15         doweq     *off
     C     *in17         andeq     *on
     C     p             andle     T#Limit                                                    238594
 
     C                   movel     MTAG          WBLK3             5
     C                   movel     '{'           WBLK3
     C                   movea     WBLK3         q@msgbuf(p)
     C                   add       5             p
 
     C                   movea     MFLD          q@msgbuf(p)
     C     q@msgbuf(p)   downe     *blank
     C                   add       1             p
     C                   enddo
     C                   movea     '}'           q@msgbuf(p)
     C                   add       1             p
 
     C     PTDL          doune     'D'
     C     *in15         oreq      *on
     C     TRNO          reade     mgomsgd0                               15
     C                   enddo
     C     *in15         ifeq      *off
     C     MTAG          lookup    TAB1                                   17
     C                   endif
 
     C                   enddo
 
     C                   endif
 
     C                   endif
      *
      ** Output Block 4 for remaining records
      *
     C                   movea     txt3          q@msgbuf(p)
     C                   add       6             p
      *
      ** Process remaining records
     C     *in15         doweq     *off
     C     p             andle     T#Limit                                                    238594
      *
      ** Set up message data in buffer
     C     ' '           checkr    MTAG          q                 5 0
     C                   movea     MTAG          q@msgbuf(p)
     C                   add       q             p
      *
     C     ' '           checkr    MFLD          q
     C                   movea     MFLD          q@msgbuf(p)
     C                   add       q             p
      *
     C     ' '           checkr    CTRC          q
     C                   movea     CTRC          q@msgbuf(p)
     C                   add       q             p
      *
      ** Read outgoing message file but ignore deleted parts
     C     PTDL          doune     'D'
     C     *in15         oreq      *on
     C     TRNO          reade     mgomsgd0                               15
     C                   enddo
      *
     C                   enddo
      *
      ** Append end of text block 4
     C                   movea     '-}'          q@msgbuf(p)
     C                   add       2             p
 
      ** Block 5 processing performed in Meridian Link
 
      ***Append*TNG*(training) and PDE (Possible Duplicate Emission)
      ***trailers*in*block {5: if required
     C*****@tandt********ifeq      '0'
     C*****MPDE**********oreq      'Y'
     C*******************movea     '{5:'         q@msgbuf(p)
     C*******************add       3             p
      *******************
      ***TNG*required*if*sender's address is Test and Training (identified
      ***by*'0'*in*position 8)
     C*****@tandt********ifeq      '0'
     C*******************movea     '{TNG:}'      q@msgbuf(p)
     C*******************add       6             p
     C*******************endif
      *******************
      ***PDE*required*if*message sent is for recovery or PDE requested
     C*****MPDE**********ifeq      'Y'
     C*****w@msgfnd******oreq      'R'
     C*******************movea     '{PDE:}'      q@msgbuf(p)
     C*******************add       6             p
     C*******************endif
      *******************
      ***Add*final*closing }
     C*******************movea     '}'           q@msgbuf(p)
     C*******************add       1             p
     C*******************endif
      *
      ** Add null termination for C
     C                   movea     w@null        q@msgbuf(p)
      *
      ** Set up sender's reference (we will use TRN)
     C                   movel(p)  TRNO          q@sndref
      *
     C                   endif
                                                                                              238594
      ** Check if SWIFT limit has been reached (estimate only)                                238594
                                                                                              238594
     C     p             ifgt      12000                                                      238594
     C                   movel     'Y'           T#Exceed                                     238594
     C                   movel(p)  '*ERROR'      q@sndref                                     238594
                                                                                              238594
      ** If spool file not already open, open it now.                                         238594
                                                                                              238594
     C     w@prtopnP1    ifne      'Y'                                                        238594
     C                   movel     'Y'           w@prtopnP1        1                          238594
     C                   open      me8200p1                                                   238594
     C                   write     me8200d1                                                   238594
     C                   endif                                                                238594
                                                                                              238594
      ** Check for overflow and rewrite headings if necessary.                                238594
     C     *in67         ifeq      *on                                                        238594
     C                   movel     *off          *in67                                        238594
     C                   write     me8200d1                                                   238594
     C                   endif                                                                238594
                                                                                              238594
      ** Extract exception report.                                                            238594
                                                                                              238594
     C                   write     me8200d2                                                   238594
     C                   endif                                                                238594
      *
      ** Pop subroutine
     C                   z-add     Save_Q        Q                                            238594
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_reset       : Reset status of pending message for this session  *
      * --------         (only if link fails)                              *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : QRCVDTAQ - Send data queue entry                  *
      *                                                                    *
      **********************************************************************
      *
     C     sr_reset      begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_reset'    @STK(Q)
      *
      ** Access last message on data queue. If found (ie. it hasn't been
      ** sent) reset its status to Ready-to-Send (RSND)
     C                   movel     p@dtqm        q@dtaq
     C                   z-add     0             q@wait
     C                   z-add     12050         q@length
     C                   call      'QRCVDTAQ'    q@rcvdtaq
      *
      ** If message found, reset status to RSND
     C     q@length      ifgt      0
     C                   movel     q@sndref      w@trn            16
     C     w@trn         chain     mgorefd0                           50
     C     *in50         ifeq      *off
     C     MGST          andeq     'PEND'
     C                   movel     'RSND'        MGST
     C                   update    mgorefd0
     C                   endif
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      *
      /EJECT                                                                                  238594
      **********************************************************************                  238594
      * sr_init        : Initialise program and session                    *                  238594
      * -------                                                            *                  238594
      *                                                                    *                  238594
      * Called by      : Mainline                                          *                  238594
      *                                                                    *                  238594
      * Calls          :                                                   *                  238594
      *                                                                    *                  238594
      **********************************************************************                  238594
      *                                                                                       238594
     C     sr_init       begsr                                                                238594
                                                                                              238594
      ** Push subroutine                                                                      238594
     C                   add       1             Q                                            238594
     C                   movel     'sr_init'     @STK(Q)                                      238594
                                                                                              238594
      ** Access bank details                                                                  238594
     C                   call      'AOBANKR0'                                                 238594
     C                   parm      *blanks       p@rtcd            7                          238594
     C                   parm      '*FIRST'      p@optn            7                          238594
     C     sdbank        parm      *blanks       dsfdy                                        238594
                                                                                              238594
      ** If the Access Object returns an error code, database error                           238594
     C     p@rtcd        ifne      *blank                                                     238594
     C                   movel     'AOBANKR0'    w0file                                       238594
     C                   movel     'bank details'w0key                                        238594
     C                   z-add     02            w0ernb                                       238594
     C                   movel     'MEM5003'     w0msgd                                       238594
     C                   movel     'MIDAS  '     w0msgf                                       238594
     C                   exsr      srerr                                                      238594
     C                   endif                                                                238594
                                                                                              238594
     C                   movel     'N'           T#Exceed          1                          238594
     C                   z-add     0             T#Count           5 0                        238594
                                                                                              238594
      ** Pop subroutine                                                                       238594
     C                   clear                   @STK(Q)                                      238594
     C                   sub       1             Q                                            238594
     C                   endsr                                                                238594
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
      /EJECT
      *****************************************************************
      /COPY MSCPYSRC,SRERRC
**CTDATA TAB1
:103:
:119:
