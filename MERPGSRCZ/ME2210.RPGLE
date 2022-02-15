000100220214     H DEBUG
000200220214     H COPYRIGHT('(c) Finastra International Limited 2021')
000300220214      *****************************************************************
000400220214/*STD *  RPGBASEBND                                                   *
000500220214/*EXI *  ALWNULL(*USRCTL)                                             *
000600220214/*EXI *  TEXT('Midas ME Purge Incoming MX Msgs - phase 1/2')          *
000700220214      *****************************************************************
000800220214      *                                                               *
000900220214      *  Midas - Message Management Module                            *
001000220214      *                                                               *
001100220214      *  ME2210 - Purge Incoming MX Transactions - Phase 1 of 2       *
001200220214      *                                                               *
001300220214      *  Function:  This program checks if an Incoming Message has    *
001400220214      *  passed it's retention period. If it has, the message details *
001500220214      *  are added to the Purge file.                                 *
001600220214      *                                                               *
001700220214      *  Called By: MEC2220 - Incoming MX Message Purge Phase 1 of 2  *
001800220214      *                                                               *
001900220214      *  (c) Finastra International Limited 2021                      *
002000220214      *                                                               *
002100220214      *  Last Amend No. CSW122  *CREATE    Date 04Oct21               *
002200220214      *                                                               *
002300220214      *---------------------------------------------------------------*
002400220214      *                                                               *
002500220214      *  CSW122 - SWIFT ISO20022 Changes                              *
002600220214      *                                                               *
002700220214      *****************************************************************
002800220214      *                                                               *
002900220214      *  Indicator usage                                              *
003000220214      *  ~~~~~~~~~~~~~~~                                              *
003100220214      *                                                               *
003200220214      *  50    First cycle                                            *
003300220214      *  60    MX-MT Join file EOF indicator                          *
003400220214      *  80    ME-MX Join file EOF indicator                          *
003500220214      *  90    ME ICD call result                                     *
003600220214      *  99    Indicator to use MDY format on date conversion         *
003700220214      *  99    Message processed indicator                            *
003800220214      *                                                               *
003900220214      *  LR    End program                                            *
004000220214      *                                                               *
004100220214      *****************************************************************
004200220214      /EJECT
004300220214
004400220214      ** Incoming MX Message file - joined with MSIXISOPD + MEISOMPD
004500220214
004600220214     FMEMXINFTJ1IF   E           K DISK    infsr(SRFILE)
004700220214
004800220214      ** Incoming MX Message file - joined with MSIXISOPD + MEISOMPD
004900220214
005000220214     FMEMXMTJ1  IF   E           K DISK    infsr(SRFILE)
005100220214
005200220214      ** Incoming MX Message Purge File
005300220214
005400220214     FMEMXINRMPDO  A E           K DISK    infsr(SRFILE)
005500220214      /EJECT
005600220214
005700220214      **  /Copy point for Array Declarations
005800220214
005900220214      /COPY ZSRSRC,ZDATE2Z1LE
006000220214
006100220214      ** /Copy point for error processing declarations
006200220214
006300220214      /COPY MECPYSRC,SRERRELE
006400220214      /COPY MECPYSRC,SRERRILE
006500220214      /EJECT
006600220214
006700220214      ** Array containing Copyright statement
006800220214
006900220214     D cpy@            S             80    dim(1) ctdata perrcd(1)
007000220214
007100220214      ** RUNDAT data area
007200220214
007300220214     D RUNDTA        E DS                  extname(RUNDAT)
007400220214
007500220214      ** Message Management ICD data structure parameter
007600220214
007700220214     D SDMGME        E DS                  extname(SDMGMEPD)
007800220214
007900220214      ** Access object data structure
008000220214
008100220214     D DSFDY         E DS                  extname(DSFDY)
008200220214
008300220214      ** Working field for value date
008400220214
008500220214     D  W@SVDT         S              6A
008600220214
008700220214      ** Purge date based on received date
008800220214
008900220214     D  WKDATE         S              5S 0
009000220214
009100220214      ** Fields for date manipulation
009200220214
009300220214     D  WMMDD          S              4S 0
009400220214     D  WYY            S              2S 0
009500220214     D  WNDAT          S              6A
009600220214     D  WKVDAT         S              5S 0
009700220214
009800220214      ** Working field for message type
009900220214
010000220214     D  WMTYP          S             20A
010100220214
010200220214      ** Working field for message id
010300220214
010400220214     D  w@msgid        S             20A
010500220214      /EJECT
010600220214      *****************************************************************
010700220214      *  Index to Subroutines                                         *
010800220214      *                                                               *
010900220214      *  sr_init       : Initialise program                           *
011000220214      *  sr_purge      : Check for purgeable messages                 *
011100220214      *  sr_write      : Write records on purge file                  *
011200220214      *  srerr         : Error processing (on copysource)             *
011300220214      *  zdate1        : Date conversion (on copysource)              *
011400220214      *                                                               *
011500220214      *****************************************************************
011600220214      /EJECT
011700220214
011800220214      ** Set up copyright statement
011900220214
012000220214     C                   movea     cpy@          bis@             80
012100220214
012200220214      **  Set up subroutine stack name
012300220214
012400220214     C                   add       1             Q
012500220214     C                   movel     'main'        @STK(Q)
012600220214
012700220214      **  Define entry parameters
012800220214
012900220214     C     *entry        plist
013000220214     C                   parm                    w0rtn             7
013100220214
013200220214      ** Push routine
013300220214
013400220214     C                   z-add     1             Q
013500220214     C                   movel     'mainline'    @STK(Q)
013600220214
013700220214      ** Initialise program
013800220214
013900220214     C     *in50         ifeq      '0'
014000220214     C                   exsr      sr_init
014100220214     C                   endif
014200220214
014300220214      ** Determine if messages may be purged
014400220214
014500220214     C                   exsr      sr_purge
014600220214
014700220214      ** Unwind subroutine stack name
014800220214
014900220214     C                   clear                   @STK(Q)
015000220214     C                   sub       1             Q
015100220214      *
015200220214     C                   seton                                        LR
015300220214      /EJECT
015400220214
015500220214      **********************************************************************
015600220214      * sr_purge       : Check if message may be purged                    *
015700220214      * --------                                                           *
015800220214      *                                                                    *
015900220214      * Called by      : main                                              *
016000220214      *                                                                    *
016100220214      * Calls          :                                                   *
016200220214      *                                                                    *
016300220214      **********************************************************************
016400220214
016500220214     C     sr_purge      begsr
016600220214
016700220214      ** Set up subroutine stack name
016800220214
016900220214     C                   add       1             Q
017000220214     C                   movel     'sr_purge'    @STK(Q)
017100220214
017200220214      ** Access the MX Index and ME Header join file to check for available records.
017300220214
017400220214     C                   read      MEMXINFTJ1                             80
017500220214     C                   dow       *in80 = *off
017600220214
017700220214      ** Move the message id to the working field
017800220214
017900220214     C                   eval      w@msgid = %trim(IMXID)
018000220214
018100220214      ** Convert SVDT from MEMXINFTJ1 to YYMMDD format
018200220214
018300220214     C
018400220214     C                   eval      W@SVDT = %subst(SVDT:3:2)
018500220214     C                             + %subst(SVDT:6:2)
018600220214     C                             + %subst(SVDT:9:2)
018700220214
018800220214      ** Get the message received date from MEMXINFTJ1
018900220214      ** Add the number of retention days to get the purge date
019000220214
019100220214     C     OMCDTE        add       ENDSMN        WKDATE
019200220214
019300220214      ** Compute for the message value date
019400220214
019500220214     C                   move      W@SVDT        WMMDD
019600220214     C                   movel     W@SVDT        WYY
019700220214     C                   move      WYY           WNDAT
019800220214     C                   movel     WMMDD         WNDAT
019900220214     C                   move      WNDAT         ZDATE
020000220214     C                   move      '1'           *in98
020100220214     C                   exsr      ZDATE1
020200220214     C                   z-add     ZDAYNO        WKVDAT
020300220214     C                   movel     IMTPY         WMTYP
020400220214
020500220214      ** Purge incoming MX messages if both the value date and the purge date has passed
020600220214
020700220214     C     WKDATE        ifle      WURDNB
020800220214     C     WKVDAT        andle     WURDNB
020900220214
021000220214      ** Check the join file if the message has already been processed
021100220214
021200220214     C     IMPF          ifeq      'Y'
021300220214     C                   seton                                        99
021400220214     C                   else
021500220214     C                   setoff                                       99
021600220214     C                   endif
021700220214
021800220214      ** If message has been processed, continue the purge analysis
021900220214     C     *in99         ifeq      '1'
022000220214
022100220214      ** If the message type is non FT, proceed with the purge
022200220214
022300220214     C                   if        %trim(%subst(IMTPY:1:4)) = 'camt'
022400220214     C                   exsr      sr_write
022500220214     C                   else
022600220214
022700220214      ** Else check MX MT Joined file if the MsgId and UETR combination exists
022800220214
022900220214     C     MXMTKL        klist
023000220214     C                   kfld                    w@msgid
023100220214     C                   kfld                    IUETR
023200220214      *
023300220214     C     MXMTKL        setll     MEMXMTJ1
023400220214     C     MXMTKL        reade     MEMXMTJ1                               60
023500220214
023600220214      ** If record is found, do not proceed with the purge
023700220214      ** This means that the record still exists on the core MT files
023800220214
023900220214     C     *in60         ifne      '0'
024000220214     C                   exsr      sr_write
024100220214     C                   endif
024200220214      *
024300220214     C                   endif
024400220214     C                   endif
024500220214     C                   endif
024600220214
024700220214      ** Read next record from the join file and continue until end of file
024800220214
024900220214     C                   read      MEMXINFTJ1                             80
025000220214      *
025100220214     C                   enddo
025200220214
025300220214      ** Unwind subroutine stack name
025400220214
025500220214     C                   clear                   @STK(Q)
025600220214     C                   sub       1             Q
025700220214      *
025800220214     C                   endsr
025900220214      /EJECT
026000220214
026100220214      **********************************************************************
026200220214      * sr_write       : Check if message may be purged                    *
026300220214      * --------                                                           *
026400220214      *                                                                    *
026500220214      * Called by      : main                                              *
026600220214      *                                                                    *
026700220214      * Calls          :                                                   *
026800220214      *                                                                    *
026900220214      **********************************************************************
027000220214
027100220214     C     sr_write      begsr
027200220214
027300220214      ** Set up subroutine stack name
027400220214
027500220214     C                   add       1             Q                 5 0
027600220214     C                   movel     'sr_write'    @STK(Q)
027700220214
027800220214      ** Build the details to be written on the purge file
027900220214
028000220214     C                   movel     IMXID         RMMXID                         Msg Id
028100220214     C                   movel     IUETR         RMUETR                         UETR
028200220214     C                   movel     ##JOB         RMAJOB                         Job Name
028300220214     C                   movel     ##USR         RMAUSR                         User Name
028400220214     C                   time                    RMATIM                         Action Time
028500220214     C                   movel     AGMRDT        RMARDT                         Action Date
028600220214     C                   movel     'I'           RMAACT                         Action Type
028700220214     C                   z-add     AGRDNB        RMRDNB                         Run Day No.
028800220214
028900220214      ** Write the record on the purge file
029000220214
029100220214     C                   write     @INRMPD
029200220214
029300220214      ** Unwind subroutine stack name
029400220214
029500220214     C                   clear                   @STK(Q)
029600220214     C                   sub       1             Q
029700220214      *
029800220214     C                   endsr
029900220214      /EJECT
030000220214
030100220214      **********************************************************************
030200220214      *                                                                    *
030300220214      *  sr_init  : Initialise and define fields                           *
030400220214      *                                                                    *
030500220214      *  Called by: main                                                   *
030600220214      *                                                                    *
030700220214      *  Calls    : srerr  - Error Processing                              *
030800220214      *                                                                    *
030900220214      **********************************************************************
031000220214
031100220214     C     sr_init       begsr
031200220214
031300220214      ** Set up subroutine stack name
031400220214
031500220214     C                   add       1             Q                 5 0
031600220214     C                   movel     'sr_init'     @STK(Q)
031700220214
031800220214      ** Get Rundate information
031900220214
032000220214     C     *DTAARA       define    RUNDAT        RUNDTA
032100220214     C                   in        RUNDTA
032200220214     C                   move      AGMRDT        wumrdt            7            Midas Run date
032300220214     C                   move      AGRDNB        wurdnb            5 0          Run day number
032400220214     C                   move      AGSUC         wusuc             1            Set up complete
032500220214     C                   move      AGDFF         wudff             1            Date Format
032600220214     C                   move      AGMBIN        wumbin            1            Multi Branched
032700220214
032800220214      ** Get Retention Days for Message Management Module
032900220214
033000220214     C                   call      'AOMGMER0'                           90
033100220214     C                   parm      *BLANKS       @rtcd             7
033200220214     C                   parm      '*FIRST '     @optn             7
033300220214     C     SDMGME        parm      SDMGME        dsfdy
033400220214
033500220214      ** If return with an error (LR seton in called program) then
033600220214      ** process for database error.
033700220214
033800220214     C     *in90         ifeq      '1'
033900220214     C     @rtcd         oreq      '*ERROR*'
034000220214     C                   movel     'AOMGMER0'    w0file
034100220214     C                   movel     '*CALL'       w0key                          ***************
034200220214     C                   z-add     1             w0ernb                         * DB ERROR 01 *
034300220214     C                   movel     'MEM5003'     w0msgd                         ***************
034400220214     C                   movel     'MIDAS  '     w0msgf
034500220214     C                   exsr      srerr
034600220214     C                   endif
034700220214
034800220214      ** If purge period is 0 set to 1.
034900220214
035000220214     C     ENDSMN        ifle      0
035100220214     C                   z-add     1             ENDSMN
035200220214     C                   endif
035300220214
035400220214      ** Indicate that set up is complete
035500220214
035600220214     C                   seton                                        50
035700220214
035800220214      ** Unwind subroutine stack name
035900220214
036000220214     C                   clear                   @STK(Q)
036100220214     C                   sub       1             Q
036200220214      *
036300220214     C                   endsr
036400220214      /EJECT
036500220214
036600220214      ** /Copy point for Date Calculations
036700220214
036800220214      /COPY ZSRSRC,ZDATE1Z2LE
036900220214      /EJECT
037000220214
037100220214      ** File and Program Error Processing
037200220214
037300220214      /COPY MECPYSRC,SRERRCLE
037400220214      /EJECT
037500220214
037600220214      ** /Copy point for Arrays
037700220214
037800220214      /COPY ZSRSRC,ZDATE2Z3
037900220214**  cpy@ table
038000220214(c) Finastra International Limited 2021
