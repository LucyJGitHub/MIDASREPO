     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MS Meridian/Alliance AFT Transmission')
      *****************************************************************
      *                                                               *
      *  Midas/SWIFT Direct Link Module                               *
      *                                                               *
      *  MS3205 - Meridian/Alliance AFT Transmission                  *
      *                                                               *
      *  Function:  This program reads all Ready-to-Send SWIFT        *
      *             messages and outputs them in SWIFT II DOS-PCC     *
      *             format for FTP transfer to SWIFT Alliance. It     *
      *             also creates the FTP script for the transfer.     *
      *                                                               *
      *  Called By: MSC3200 - Alliance automated transmission         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD051013           Date 24May18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244940             Date 29Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 236012 (Bug 8951)  Date 29Mar05               *
      *                 Bug8952            Date 12Oct05               *
      *                 219242             Date 01Jul03               *
      *                 219241             Date 01Jul03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW027 *CREATE     Date 21May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD051013 - File name is truncated and header is not printed. *
      *  MD046248 - Finastra Rebranding                               *
      *  244940 - Report should not be generated if there are no      *
      *           messages to report                                  *
      *  236012 - Do Not perform deletion Deletion of mXX.nnn file    *
      *           here as the the previous PUT command may not be     *
      *           guaranted succesful. Applied fix 231766.            *
      *  BUG8952- The name of the file being processed is not being   *
      *           printed on report.                                  *
      *  219242 - Not possible to create MT103+ payment msg from      *
      *           non-FT transaction (Recompile)                      *
      *  219241 - Defaulting of "Details of Charges" assign a         *
      *           system value (Recompile)                            *
/*    *  CSW027 - Midas message manager AFT interface                 *
      *                                                               *
      *****************************************************************
     FMSLISTPD  IF   E             disk    infsr(srfile)
     F                                     rename(mslistpd:mslistd0)
     FMSFTTIPD  O    E             disk    infsr(srfile)
     F***MS3200AU**O    E             printer oflind(*in66)                                   244940
     FMS3200AU  O    E             printer oflind(*in66) usropn                               244940
      *
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
     D  w@msg          DS         10240
     D  w@msgbuf               1  10240
     D                                     dim(10240)
     D  w@msgout               1  10240
     D                                     dim(20)
      ** buffers for outgoing message
      *
     D                 DS
     D  w@seqn                 1      3  0
     D  w@seqa                 1      3
      ** Sequence numbers for Alliance file name in FTP script
      *
     D                 DS
     D  SIFTPO                 1    128
     D  w@in4                  1      4
     D  w@in5                  1      5
      ** Analyse FTP output
      *
      ** Control codes and fixed texts
      /COPY MSCPYSRC,SRERRD
     Imslistd0
     I              mslistpd                    aftmsg
      /EJECT
      *****************************************************************
      *  Index to Subroutines                                         *
      *                                                               *
      *  sr_init       : Initialise program                           *
      *  sr_ftp        : Create FTP script file for transfer          *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Output parameter: o@msgs = 'Y' if any messages found, else 'N'
     C     *entry        plist
     C                   parm                    o@msgs            1
      *
      ** Initialise program
     C                   exsr      sr_init
     C                   exsr      sr_ftp
      *
      ** Write audit or 'no details to report'
     C*****o@msgs        ifeq      'Y'                                                       BUG8952
     C***********        write     ms3200f4                                                  BUG8952
     C***********        else                                                                BUG8952
     C*****o@msgs        ifeq      'N'                                                BUG8952 244940
     C**********         write     ms3200f3                                                   244940
     C**********         endif                                                                244940
     C     o@msgs        ifeq      'Y'                                                        244940
     C     w@alfil       ifne      *blanks                                                    244940
     C                   if        not %open(ms3200au)                                        244940
     C                   open      ms3200au                                                   244940
     C                   write     ms3200f1                                                 MD051013
     C                   endif                                                                244940
     C                   write     ms3200f6
     C                   endif                                                                244940
     C                   endif                                                                244940
      *
      ** Terminate
     C/COPY WNCPYSRC,MS3200C008
     C                   move      *on           *inlr
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
      ** Access output of list operation to get filenames
     C     1             setll     MSLISTD0
     C                   read      MSLISTD0                               55
      *
     C     *in55         ifeq      '1'
     C                   movel     'N'           o@msgs
      *
     C                   else
     C                   movel     'Y'           o@msgs
      *
      ** Line 1: <User> <Password> (sign on to Alliance machine)
     C     ENSUSR        cat(p)    ENSPWD:1      SIFTPI
     C                   write     MSFTPID0
      *
      ** Line 2: NAMEFMT 1 (for IFS file system)
     C                   movel(p)  'NAMEFMT 1'   SIFTPI
     C                   write     MSFTPID0
      *
      ** Line 3: LCD <path name> (change local directory)
     C     'LCD'         cat(p)    ENLPHO:1      SIFTPI
     C                   write     MSFTPID0
      *
      ** Line 4: TYPE I (for 'image' i.e. transfer file in binary form)
     C                   movel(p)  'TYPE I'      SIFTPI
     C                   write     MSFTPID0
      *
      ** Line 5: CD <path name> (change directory)
     C     'CD'          cat(p)    ENSPHO:1      SIFTPI
     C                   write     MSFTPID0
      *
     C     *in55         doweq     '0'
     C     w@nofiles     andlt     999
      *
      ** increment sequence number
     C                   add       1             w@nofiles         3 0
      *
      ** create version of AFT file with # prefix
     C     '#'           cat(p)    AFTMSG:0      @AFTMSG          30
      *
      ** Line 6: PUT <Midas file> #<Alliance file> (transfer file)
     C     'PUT'         cat(p)    AFTMSG:1      SIFTPI
     C                   cat       @AFTMSG:1     SIFTPI
     C                   write     MSFTPID0
     C/COPY WNCPYSRC,MS3200C007
      *
      ** Line 7: REN #<Alliance file> <Alliance file> (rename: see note 2)
     C     'REN'         cat(p)    @AFTMSG:1     SIFTPI
     C                   cat       AFTMSG:1      SIFTPI
     C                   write     MSFTPID0
      *
      ** Line 8: DEL <filename> (delete file)
     C*****'SYSCMD'      cat(p)    'DEL ''':1    SIFTPI                                       236012
     C*****              cat       ENLPHO:0      SIFTPI                                       236012
     C*****              cat       '/':0         SIFTPI                                       236012
     C*****              cat       AFTMSG:0      SIFTPI                                       236012
     C*****              cat       '''':0        SIFTPI                                       236012
     C*****              write     msftpid0                                                   236012
      *
      *  Move the file name from MSLISTPD to the output field for the report                 BUG8952
      *                                                                                      BUG8952
     C                   movel     AFTMSG        W@ALFIL                                     BUG8952
      *  Write the file name to the printer file                                             BUG8952
     C                   if        not %open(ms3200au)                                        244940
     C                   open      ms3200au                                                   244940
     C                   write     ms3200f1                                                 MD051013
     C                   endif                                                                244940
     C                   write     ms3200f4                                                  BUG8952
      *                                                                                      BUG8952
      ** Read next file name
     C                   read      MSLISTD0                               55
     C                   enddo
      *
      ** Line 9: QUIT (end FTP session)
     C                   movel(p)  'QUIT'        SIFTPI
     C                   write     MSFTPID0
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
      ** Define all data areas
     C     *dtaara       define                  msstat2
     C                   SETON                                        85                    MD051013
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
     C                   if        not %open(ms3200au)                                        244940
     C                   open      ms3200au                                                   244940
     C                   endif                                                                244940
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
     C                   if        not %open(ms3200au)                                        244940
     C                   open      ms3200au                                                   244940
     C                   endif                                                                244940
     C                   write     ms3200f1
     C                   write     ms3200f5
     C                   exsr      srerr
     C                   endif
     C/COPY WNCPYSRC,MS3200C003
      *
      ** Write audit report headings
     C                   move      *on           *in66                                        244940
     C**********         write     ms3200f1                                                   244940
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
