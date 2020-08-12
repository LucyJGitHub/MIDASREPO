     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MS create o/g mex in DOS-PCC fmt. - LCI020')     *
      *****************************************************************
      *                                                               *
      *  Midas/SWIFT Direct Link Module                               *
      *                                                               *
      ***MSL0001*-*Create*outgoing*mex*file*in*DOS-PCC*fmt.*-*LCI020***                   LCI020
      *  XX020001 - Create outgoing mex file in DOS-PCC fmt. - LCI020 *                   LCI020
      *                                                               *
      *  Function:  This program is loosely based on MS3200. Check    *
      *             that program to see if any fix should be applied  *
      *             here as well.                                     *
      *                                                               *
      *  Called By: MSC3200 - Alliance automated transmission         *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD053940           Date 27Jul20               *
      *  Prev Amend No. LCI020             Date 22Jun18               *
      *                 LCI020  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053940 - Compilation error. Adjust length of W@ALFIL field *
      *             from 14 to 30.                                    *
      *  LCI020 - Upgrade to FBM 2.1                                  *
      *  LCI020 - Enable Inter.Pel transmission of SWIFT outgoing     *
      *           messages from Midas                                 *
      *                                                               *
      *****************************************************************
      /EJECT
     F**********MSLPCCPP  IF   E             disk    infsr(srfile)                       LCI020
     FXXLPCCPP  IF   E             disk    infsr(srfile)                                 LCI020
     FMSPCCOPD  O    E             disk    infsr(srfile)
     FMSFTTIPD  O    E             disk    infsr(srfile)
     FMS3200AU  O    E             printer oflind(*in66)
      /EJECT
     D cpy@            S             80    dim(1) ctdata perrcd(1)
      ** Array containing Copyright statement
      *
     D TAB1            S              5A   ctdata perrcd(1) dim(2)
      ** Table containing valid Block 3 Codes
      *
     D dssdy         E DS                  extname(DSSDY)
      ** Data Structures used by access objects
      *
     D sdbank        E DS                  extname(SDBANKPD)
      ** Bank details ICD
      *
     D sdmgme        E DS                  extname(SDMGMEPD)
      ** Message Generation/Message Management ICD
      *
     D  msstat2      E DS                  extname(MSSTAT2)
      ** Midas/SWIFT Direct Link status data area # 2 (new for CSW009)
      *
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
     D                 DS
     D**w@cr*******************5      5    inz(x'd0')
     D  w@cr                   5      5    inz(x'0d')
     D  w@lf                   6      6    inz(x'25')
     D  w@crlf                 5      6
      *
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
     C                   else
     C                   write     ms3200f3
     C                   endif
     C                   write     ms3200f6
      *
      ** Terminate
     C                   move      *on           *inlr
      /EJECT
      **********************************************************************
      * sr_detail      : Detail processing: access messages and write      *
      * ---------        to transfer file                                  *
      *                                                                    *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
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
      ** Read temp file
     C**********         read      MSLPCCP0                               50             LCI020
     C                   read      XXLPCCP0                               50             LCI020
      *
      ** Set flag for messages found
     C     *in50         ifeq      '0'
     C                   movel     'Y'           o@msgs
     C                   endif
      *
      ** For each message...
     C     *in50         doweq     '0'
      *
      ** Move data into blocks
     C                   clear                   w@msgbuf
     C                   movea     w@soh         w@msgbuf(1)
     C                   movea     I@SIDATA      w@msgbuf(2)
      *
     C                   z-add     1             ix                5 0
     C                   z-add     1             ix2               5 0
     C                   move      *blanks       w@msgbuf1     10240
     C                   move      *off          *in80
     C                   dow       not *in80
     C     w@lf          scan      w@msg:ix2     ix
     C                   if        %found
     C                   movea(p)  w@msgbuf(ix)  w@msgbuf1
     C                   eval      w@msgbuf(ix) = w@cr
     C                   eval      ix = ix + 1
     C                   movea     w@msgbuf1     w@msgbuf(ix)
     C                   eval      ix2 = ix + 1
     C                   else
     C                   move      *on           *in80
     C                   endif
     C                   enddo
      *
     C*****' '           checkr    I@SIDATA      a                 5 0
     C     ' '           checkr    w@msg         a                 5 0
     C*****              eval      a = a + 2
     C                   eval      a = a + 1
     C                   movea     w@etx         w@msgbuf(a)
      *
      ** Write to output file for FTP transfer
     C                   exsr      sr_write
      *
     C**********         read      MSLPCCP0                               50             LCI020
     C                   read      XXLPCCP0                               50             LCI020
     C                   enddo
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
     C*****ENSRFO        cat       '.':0         w@alfil          14                        MD053940
     C     ENSRFO        cat       '.':0         w@alfil          30                        MD053940
     C                   cat       w@seqa:0      w@alfil
     C*****'#'**         cat       w@alfil:0     w@#alfil         15                        MD053940
     C     '#'           cat       w@alfil:0     w@#alfil         31                        MD053940
      *
      ** Line 1: <User> <Password> (sign on to Alliance machine)
     C     ENSUSR        cat(p)    ENSPWD:1      SIFTPI
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
      ** Border line indicators for message management
     C                   movel     'Y'           NewMex            1
     C                   movel     'N'           EndMex            1
     C                   z-add     0             CrPos             5 0
     C                   z-add     1             CrPosOld          5 0
     C                   z-add     0             CrPosNxt          5 0
     C                   z-add     0             mexnumb           5 0
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
     C                   write     ms3200f1
     C                   write     ms3200f5
     C                   exsr      srerr
     C                   endif
      *
      ** Write audit report headings
     C                   write     ms3200f1
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
(c) Finastra International Limited 2018
** TAB1                                                                                       CDL008
:103:                                                                                         CDL008
:119:                                                                                         CFT014
