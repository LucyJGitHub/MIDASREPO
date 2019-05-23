     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MS create o/g messages in DOS-PCC format')       *
      *****************************************************************
      *                                                               *
      *  Midas/SWIFT Direct Link Module                               *
      *                                                               *
      *  MS3200 - Create outgoing message file in DOS-PCC format      *
      *                                                               *
      *  Function:  This program reads all Ready-to-Send SWIFT        *
      *             messages and outputs them in SWIFT II DOS-PCC     *
      *             format for FTP transfer to SWIFT Alliance. It     *
      *             also creates the FTP script for the transfer.     *
      *                                                               *
      *  Called By: MSC3200 - Alliance automated transmission         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD101             Date 07Dec18               *
      *  Prev Amend No. MD051013           Date 24May18               *
      *                 CSW218             Date 19Mar18               *
      *                 MD046248           Date 27Oct17               *
      *                 240269             Date 19Aug14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244940             Date 17Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 219242             Date 01Jul03               *
      *                 219241             Date 01Jul03               *
      * Midas Release 4.01 -------------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187213             Date 21Nov00               *
      *                 CFT014             Date 14Sep00               *
      *                 CFT013             Date 14Sep00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSW009 *CREATE     Date 14Feb97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD101 - Password Encryption                                 *
      *  MD051013 - File name is truncated and header is not printed. *
      *  CSW218 - SWIFT Changes 2018                                  *
      *  MD046248 - Finastra Rebranding                               *
      *  240269 - SWIFT skip a blank character when it falls on the   *
      *           50th position. Applied fix 221026 or 240192.        *
      *  244940 - Applied fix 233575.                                 *
      *  233575 - Report should not be generated if there are no      *
      *           messages to report.                                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  219242 - Not possible to create MT103+ payment msg from      *
      *           non-FT transaction (Recompile)                      *
      *  219241 - Defaulting of "Details of Charges" assign a         *
      *           system value (Recompile)                            *
      *  187213 - Support block 3 processing for TI Interface         *
      *  CFT014 - MT103 Message Generation for FT                     *
      *  CFT013 - MT103 Message Generation for Non-FT                 *
      *           joint change with CFT014                            *
      *  CDL008 - Continuous Linked Settlement                        *
      *  CSW009 - Midas-SWIFT Alliance Automated File Transfer        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Notes:                                                       *
      *  ------                                                       *
      *                                                               *
      *  1. Formatted SWIFT messages are converted to ASCII for       *
      *     processing by Alliance. FTP's standard conversion is not  *
      *     used because it doesn't convert CrLf correctly. The FTP   *
      *     file transfer type 'I' (image) is specified in the FTP    *
      *     script file to prevent further conversion.                *
      *                                                               *
      *  2. The FTP script transfers the messages to a file on        *
      *     Alliance named #<filename>.nnn which is subsequently      *
      *     renamed to <filename>.nnn. Alliance should be set up to   *
      *     ignore filenames beginning '#' on the Message Partner     *
      *     definition. This is to prevent Alliance accessing an      *
      *     incomplete file.                                          *
      *                                                               *
      *****************************************************************
      /EJECT
     F/COPY WNCPYSRC,MS3200F001
     FMGOREFL3  UF   E           K disk    infsr(srfile)
     FMGOMSGPD  IF   E           K disk    infsr(srfile)
     FMSPCCOPD  O    E             disk    infsr(srfile)
     FMSFTTIPD  O    E             disk    infsr(srfile)
     F***MS3200AU**O    E             printer oflind(*in66)                                   233575
     FMS3200AU  O    E             printer oflind(*in66) usropn                               233575
      /EJECT
     D cpy@            S             80    dim(1) ctdata perrcd(1)
      ** Array containing Copyright statement
      *
     D*TAB1************S              5A   ctdata perrcd(1) dim(1)                     CDL008 CFT014
     D*TAB1************S              5A   ctdata perrcd(1) dim(2)                     CFT014 CSW218
     D TAB1            S              5A   ctdata perrcd(1) dim(3)                            CSW218
                                                                                              CSD101
     D Password        S            128                                                       CSD101
     D PReturnCode     S              7A                                                      CSD101
     D PAction         S              1A                                                      CSD101
     D PValidList      S             10A   INZ('SDINTFVL')                                    CSD101
     D PLibrary        S             10A                                                      CSD101
     D PIDName         S            100A                                                      CSD101
     D PPass1          S            128A                                                      CSD101
     D PDescr          S           1000A                                                      CSD101
      ** Table containing valid Block 3 Codes                                                 CDL008
      *                                                                                       CDL008
     D dssdy         E DS                  extname(DSSDY)
      ** Data Structures used by access objects
      *
     D/COPY WNCPYSRC,MS3200D001
     D sdbank        E DS                  extname(SDBANKPD)
      ** Bank details ICD
      *
     D sdmgme        E DS                  extname(SDMGMEPD)
      ** Message Generation/Message Management ICD
      *
     D  msstat2      E DS                  extname(MSSTAT2)
      ** Midas/SWIFT Direct Link status data area # 2 (new for CSW009)
      *
     D/COPY WNCPYSRC,MS3200D002
     D  sdstat       E DS                  extname(SDSTAT)
     Dren@mode       E                     extfld(MODE)
      ** SDSTAT for system prefix
      *
     D  w@msg          DS         10240
     D  w@msgbuf               1  10240
     D                                     dim(10240)
     D  w@msgout               1  10240
     D                                     dim(20)
      ** buffers for outgoing message
      *
     D                 DS
     D  w@nwds                 1     20
     D  w@dbic                 1      8
     D  w@dbrch                9     11
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
     D  w@mifil        DS
     D  w@pfx                  1      2
     D  w@fil                  3     25    inz('DPLIB/MSPCCOPD.MSPCCOPD')
      ** Define Midas DOS-PCC output file for inclusion in FTP script
      *
     D                 DS
     D  w@seqn                 1      3  0
     D  w@seqa                 1      3
      ** Sequence numbers for Alliance file name in FTP script
      *
      /SPACE 2
     D  w@txt4         S              4A   inz('}{3:')                                        CDL008
      *                                                                                       CDL008
     D                 DS
     D  w@tx3                  1      4    inz('}{4:')
     D  w@cr                   5      5    inz(x'0d')
     D  w@lf                   6      6    inz(x'25')
     D  w@crlf                 5      6
     D  txt3                   1      6
     Dw@soh            S              1    inz(x'01')
     Dw@etx            S              1    inz(x'03')
      ** Control codes and fixed texts
      /COPY MSCPYSRC,SRERRD
      /EJECT
      *****************************************************************
      *  Index to Subroutines                                         *
      *                                                               *
      *  sr_init       : Initialise program                           *
      *  sr_detail     : Detail processing                            *
      *  sr_format     : Format message for transmission              *
      *  sr_write      : Write to output file for FTP transfer        *
      *  sr_ftp        : Create FTP script file for transfer          *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Output parameter: o@msgs = 'Y' if any messages found, else 'N'
     C     *entry        plist
     C                   parm                    o@msgs            1
      *
      ** Set up copyright parameter
     C                   movea     cpy@          cpy2@            80
      *
      ** Initialise program
     C                   exsr      sr_init
      *
      ** Access ready-to-send messages and write to file
     C                   exsr      sr_detail
      *
      ** If any messages output prepare FTP script file for transmission
      ** else write 'no details to report' to audit
     C     o@msgs        ifeq      'Y'
     C                   exsr      sr_ftp
     C                   write     ms3200f4
     C**********         else                                                                 233575
     C**********         write     ms3200f3                                                   233575
     C**********         endif                                                                233575
     C                   write     ms3200f6
     C                   endif                                                                233575
      *
      ** Terminate
     C/COPY WNCPYSRC,MS3200C008
     C                   move      *on           *inlr
      /EJECT
      **********************************************************************
      * sr_detail      : Detail processing: access messages and write      *
      * ---------        to transfer file                                  *
      *                                                                    *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : sr_format                                         *
      *                  sr_write                                          *
      *                                                                    *
      **********************************************************************
      *
     C     sr_detail     begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_detail'   @STK(Q)
      *
      ** Read first ready-to-send message
     C     *loval        setll     mgorefd0
     C                   read      mgorefd0                               50
      *
      ** Set flag for messages found
     C     *in50         ifeq      '0'
     C                   movel     'Y'           o@msgs
     C                   endif
     C/COPY WNCPYSRC,MS3200C011
      *
      ** For each message...
     C     *in50         doweq     '0'
     C/COPY WNCPYSRC,MS3200C009
      *
      ** Create SWIFT II DOS-PCC format
     C                   exsr      sr_format
      *
      ** Write to output file for FTP transfer
     C                   exsr      sr_write
      *
      ** Update status to PEND/ing Transmission
     C                   movel     'PEND'        MGST
     C                   update    mgorefd0
      *
      ** Write details to audit
     C     *in66         ifeq      *on
     C                   movel     *off          *in66
     C                   if        w#auopen = '0'                                             233575
     C                   open      ms3200au                                                   233575
     C                   move      '1'           w#auopen                                     233575
     C                   endif                                                                233575
     C                   write     ms3200f1
     C                   endif
     C                   write     ms3200f2
     C/COPY WNCPYSRC,MS3200C010
      *
     C                   read      mgorefd0                               50
     C                   enddo
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
      * Called by      : sr_detail                                         *
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
     C                   movel     'MGOMSGPD'    w0file
     C                   movel(p)  TRNO          w0key
     C                   z-add     03            w0ernb
     C                   movel     'MEM5004'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   if        w#auopen = '0'                                             233575
     C                   open      ms3200au                                                   233575
     C                   move      '1'           w#auopen                                     233575
     C                   endif                                                                233575
     C                   write     ms3200f1
     C                   write     ms3200f5
     C                   exsr      srerr
     C                   else
      *
      ** Set 'Start-of-Message'
     C                   clear                   w@msgbuf
     C                   movea     w@soh         w@msgbuf(1)
      *
      ** Expand destination address to 12 characters with 'X' between
      ** BIC and branch code, and branch code 'XXX' if not quoted.
     C                   movel(p)  NWDS          w@nwds
     C     w@dbrch       ifeq      *blanks
     C                   movel     'XXX'         w@dbrch
     C                   endif
     C                   movel(p)  w@dbic        @dst2
     C     @dst2         cat       'X':0         @dst2
     C     @dst2         cat       w@dbrch:0     @dst2
      *
      ** Set up sender's address and write SWIFT II header to message buffer
     C                   movel     NWSN          @snd2
     C                   z-add     2             a                 5 0
     C                   movea     @sw2          w@msgbuf(a)
     C                   add       49            a
      *
      ** Write delivery notification to message buffer if not blank,
      ** followed by end of block 2, start of block 4.
     C     DELC          ifne      '0'
     C     DELC          andne     ' '
     C                   movea     DELC          w@msgbuf(a)
     C                   add       1             a
     C                   endif
      * Add processing for block 3                                              187213
      *                                                                         187213
     C     MTAG          ifeq      '3:   '                                      187213
      *                                                                         187213
      * add to data structure                                                   187213
      *                                                                         187213
      * end block 2                                                             187213
     C                   movea     '}{3:'        w@msgbuf(a)                    187213
     C                   add       4             a                              187213
      *                                                                         187213
      * format start block 3                                                    187213
     C     ')(':'}{'     xlate     MFLD          MFLD                           187213
      *                                                                         187213
      * add data for block 3                                                    187213
     C     ' '           checkr    MFLD          b                              187213
     C                   movea     MFLD          w@msgbuf(a)                    187213
     C                   add       b             a                              187213
      *                                                                         187213
      * end block 3                                                             187213
     C                   movea     '}'           w@msgbuf(a)                    187213
     C                   add       1             a                              187213
      *                                                                         187213
      * Read next record                                                        187213
      *                                                                         187213
     C     TRNO          reade     mgomsgd0                               15    187213
     C                   endif                                                  187213
      *                                                               *         187213
     C/COPY WNCPYSRC,MS3200C002
                                                                                              CDL008
      ** Output all Block 3 details first before Block 4                                      CDL008
                                                                                              CDL008
     C     *in15         ifeq      *off                                                       CDL008
                                                                                              CDL008
     C     MTAG          lookup    TAB1                                   17                  CDL008
                                                                                              CDL008
     C     *in17         ifeq      *on                                                        CDL008
                                                                                              CDL008
     C                   movea     w@txt4        w@msgbuf(a)                                  CDL008
     C                   add       4             a                                            CDL008
                                                                                              CDL008
     C     *in15         doweq     *off                                                       CDL008
     C     *in17         andeq     *on                                                        CDL008
                                                                                              CDL008
     C                   movel     MTAG          WBLK3             5                          CDL008
     C                   movel     '{'           WBLK3                                        CDL008
     C                   movea     WBLK3         w@msgbuf(a)                                  CDL008
     C                   add       5             a                                            CDL008
                                                                                              CDL008
     C                   movea     MFLD          w@msgbuf(a)                                  CDL008
     C     w@msgbuf(a)   downe     *blank                                                     CDL008
     C                   add       1             a                                            CDL008
     C                   enddo                                                                CDL008
     C                   movea     '}'           w@msgbuf(a)                                  CDL008
     C                   add       1             a                                            CDL008
                                                                                              CDL008
     C     PTDL          doune     'D'                                                        CDL008
     C     *in15         oreq      *on                                                        CDL008
     C     TRNO          reade     mgomsgd0                               15                  CDL008
     C                   enddo                                                                CDL008
     C     *in15         ifeq      *off                                                       CDL008
     C     MTAG          lookup    TAB1                                   17                  CDL008
     C                   endif                                                                CDL008
                                                                                              CDL008
     C                   enddo                                                                CDL008
                                                                                              CDL008
     C                   endif                                                                CDL008
                                                                                              CDL008
     C                   endif                                                                CDL008
      *                                                                                       CDL008
      ** Output Block 4 for remaining records                                                 CDL008
      *
     C                   movea     txt3          w@msgbuf(a)
     C                   add       6             a
     C/COPY WNCPYSRC,MS3200C001
      *
      ** Process remaining records
     C     *in15         doweq     *off
      *
     C/COPY WNCPYSRC,MS3200C012
      ** Set up message data in buffer
     C     ' '           checkr    MTAG          b                 5 0
     C                   movea     MTAG          w@msgbuf(a)
     C                   add       b             a
      *
     C     ' '           checkr    MFLD          b
      *                                                                                       240269
      ** Add a blank character to the position 50 to avoid skipping.                          240269
      *                                                                                       240269
     C     b             ifeq      49                                                         240269
     C     CTRC          andeq     *blanks                                                    240269
     C                   add       1             b                                            240269
     C                   endif                                                                240269
      *                                                                                       240269
     C                   movea     MFLD          w@msgbuf(a)
     C                   add       b             a
      *
     C     ' '           checkr    CTRC          b
     C                   movea     CTRC          w@msgbuf(a)
     C                   add       b             a
      *
     C/COPY WNCPYSRC,MS3200C013
      ** Read outgoing message file but ignore deleted parts
     C     PTDL          doune     'D'
     C     *in15         oreq      *on
     C     TRNO          reade     mgomsgd0                               15
     C                   enddo
     C/COPY WNCPYSRC,MS3200C005
      *
     C                   enddo
      *
      ** Append end of text block 4
     C                   movea     '-}'          w@msgbuf(a)
     C                   add       2             a
      *
      ** Append TNG (training) and PDE (Possible Duplicate Emission)
      ** trailers in block {5: if required
     C     @tandt        ifeq      '0'
     C     MPDE          oreq      'Y'
     C                   movea     '{5:'         w@msgbuf(a)
     C                   add       3             a
      *
      ** TNG required if sender's address is Test and Training (identified
      ** by '0' in position 8)
     C     @tandt        ifeq      '0'
     C                   movea     '{TNG:}'      w@msgbuf(a)
     C                   add       6             a
     C                   endif
      *
      ** If PDE requested add {PDE:} field
     C     MPDE          ifeq      'Y'
     C                   movea     '{PDE:}'      w@msgbuf(a)
     C                   add       6             a
     C                   endif
      *
      ** Add final closing }
     C                   movea     '}'           w@msgbuf(a)
     C                   add       1             a
     C                   endif
      *
      ** Add End-of-Text
     C                   movea     w@etx         w@msgbuf(a)
     C/COPY WNCPYSRC,MS3200C006
      *
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_write       : Write to output file for FTP transfer             *
      * --------                                                           *
      *                                                                    *
      * Called by      : sr_detail                                         *
      *                                                                    *
      * Calls          : API: QDCXLATE (character set conversion)          *
      *                                                                    *
      **********************************************************************
      *
     C     sr_write      begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_write'    @STK(Q)
      *
      ** Convert from EBCDIC to ASCII and write to output file
     C                   z-add     1             x                 5 0
     C     w@msgout(x)   downe     *blanks
      *
     C                   call      'QDCXLATE'
     C                   parm      512           p@lngth           5 0
     C                   parm      w@msgout(x)   p@buf           512
     C                   parm      'QTCPASC'     p@tblin          10
     C                   parm      'QUSRSYS'     p@libin          10
      *
     C                   movel(p)  p@buf         SIDATA
     C                   write     mspccod0
     C                   add       1             x
     C                   enddo
     C/COPY WNCPYSRC,MS3200C004
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_ftp         : Create FTP script file for transfer               *
      * ------                                                             *
      *                                                                    *
      * Called by      : mainline                                          *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_ftp        begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_ftp'      @STK(Q)
      *
      ** Create remote filename in form <filename>.nnn where 'nnn' is a
      ** a sequence number from dtaara/msstat2. Also create version with
      ** # prefix: #<filename>.nnn. Increment sequence for each new file.
     C     *lock         in        msstat2
     C                   movel     SICSEQ        w@seqa
     C     w@seqa        ifeq      *blanks
     C     w@seqa        oreq      '000'
     C                   z-add     1             w@seqn
     C                   else
     C                   add       1             w@seqn
     C                   endif
     C                   move      w@seqa        SICSEQ
     C                   out       msstat2
      *
     C/COPY WNCPYSRC,MS3200C014
     C*****ENSRFO        cat       '.':0         w@alfil          14                        MD051013
     C     ENSRFO        cat       '.':0         w@alfil          30                        MD051013
     C                   cat       w@seqa:0      w@alfil
     C*****'#'           cat       w@alfil:0     w@#alfil         15                        MD051013
     C     '#'           cat       w@alfil:0     w@#alfil         31                        MD051013
     C/COPY WNCPYSRC,MS3200C015
      *
      ** Line 1: <User> <Password> (sign on to Alliance machine)
     C*****ENSUSR        cat(p)    ENSPWD:1      SIFTPI                                       CSD101
      *                                                                                       CSD101
      ** Check User ID if exists, then retrieve the password.                                 CSD101
      *                                                                                       CSD101
     C                   EVAL      Password = *Blanks                                         CSD101
      *                                                                                       CSD101
     C                   IF        ENSUSR <> *BLANKS                                          CSD101
     C                   EVAL      PLibrary = LIBR + 'DMLIB'                                  CSD101
     C                   EVAL      PIDName = 'SWIFTALLIANCE_' + ENSUSR                        CSD101
                                                                                              CSD101
     C                   CALL      'SD000404'                                                 CSD101
     C                   PARM      *Blanks       PReturnCode                                  CSD101
     C                   PARM      'F'           PAction                                      CSD101
     C                   PARM                    PValidList                                   CSD101
     C                   PARM                    PLibrary                                     CSD101
     C                   PARM                    PIDName                                      CSD101
     C                   PARM      *Blanks       PPass1                                       CSD101
     C                   PARM      *Blanks       PDescr                                       CSD101
                                                                                              CSD101
     C                   IF        PReturnCode = *Blanks                                      CSD101
     C                   EVAL      Password = PPass1                                          CSD101
     C                   ENDIF                                                                CSD101
     C                   ENDIF                                                                CSD101
                                                                                              CSD101
     C     ENSUSR        cat(p)    Password:1    SIFTPI                                       CSD101
                                                                                              CSD101
     C                   write     MSFTPID0
      *
      ** Line 2: TYPE I (for 'image' i.e. transfer file in binary form)
     C                   movel(p)  'TYPE I'      SIFTPI
     C                   write     MSFTPID0
      *
      ** Line 3: CD <path name> (change directory)
     C     'CD'          cat(p)    ENSPHO:1      SIFTPI
     C                   write     MSFTPID0
      *
      ** Line 4: PUT <Midas file> #<Alliance file> (transfer file)
     C     'PUT'         cat(p)    w@mifil:1     SIFTPI
     C                   cat       w@#alfil:1    SIFTPI
     C                   write     MSFTPID0
     C/COPY WNCPYSRC,MS3200C007
      *
      ** Line 5: REN #<Alliance file> <Alliance file> (rename: see note 2)
     C     'REN'         cat(p)    w@#alfil:1    SIFTPI
     C                   cat       w@alfil:1     SIFTPI
     C                   write     MSFTPID0
      *
      ** Line 6: QUIT (end FTP session)
     C                   movel(p)  'QUIT'        SIFTPI
     C                   write     MSFTPID0
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
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_init       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_init'     @STK(Q)
      *
      ** Initialise output parameter
     C                   movel     'N'           o@msgs
      *
      ** Define all data areas
     C     *dtaara       define                  sdstat
     C     *dtaara       define                  msstat2
      *
      ** Access system prefix
     C                   in        sdstat
     C                   movel     LIBR          w@pfx
      *
      ** Access bank details
     C                   call      'AOBANKR0'
     C                   parm      *blanks       p@rtcd            7
     C                   parm      '*FIRST'      p@optn            7
     C     sdbank        parm      *blanks       dssdy
      *
      ** If the Access Object returns an error code, database error
     C     p@rtcd        ifne      *blank
     C                   movel     'AOBANKR0'    w0file
     C                   movel     'Bank details'w0key
     C                   z-add     01            w0ernb
     C                   movel     'MEM5003'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   open      ms3200au                                                   233575
     C                   write     ms3200f1
     C                   write     ms3200f5
     C                   exsr      srerr
     C                   endif
      *
      ** Access Message Generation/Message Management ICD
     C                   call      'AOMGMER1'
     C                   parm      *blanks       p@rtcd            7
     C                   parm      '*FIRST'      p@optn            7
     C     sdmgme        parm      *blanks       dssdy
      *
      ** If the Access Object returns an error code, database error
     C     p@rtcd        ifne      *blank
     C                   movel     'AOMGMER1'    w0file
     C                   movel     'MG/ME ICD'   w0key
     C                   z-add     02            w0ernb
     C                   movel     'MEM5003'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   open      ms3200au                                                   233575
     C                   write     ms3200f1
     C                   write     ms3200f5
     C                   exsr      srerr
     C                   endif
     C/COPY WNCPYSRC,MS3200C003
      *
      ** Write audit report headings
     C                   move      *on           *in66                                        233575
     C                   move      '0'           w#auopen          1                          233575
     C**********         write     ms3200f1                                                   233575
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
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      *
      ********************************************************************
      /COPY MSCPYSRC,SRERRC
**  CPY@
(c) Finastra International Limited 2001
** TAB1                                                                                       CDL008
:103:                                                                                         CDL008
:119:                                                                                         CFT014
:121:                                                                                         CSW218
