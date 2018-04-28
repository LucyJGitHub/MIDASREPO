     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MS create FTP scripts for incoming messages')    *
      *****************************************************************
      *                                                               *
      *  Midas/SWIFT Direct Link Module                               *
      *                                                               *
      *  MS3250 - Create FTP scripts for incoming messages            *
      *                                                               *
      *  Function:  This program creates two FTP scripts. The first   *
      *             requests a list of all files on Alliance which    *
      *             match the pattern specified for incoming          *
      *             messages on the ICD. The second transfers each    *
      *             file on the list to the AS/400 and deletes it     *
      *             from Alliance.                                    *
      *                                                               *
      *  Called By: MSC3250 - Alliance automated receive              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
     a*                                                               *
      *  Last Amend No. AR782465           Date 19Aug14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 247997             Date 31May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 219242             Date 01Jul03               *
      *                 219241             Date 01Jul03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW027             Date 21May02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 191165             Date 16Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 165212             Date 30Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 147256             Date 16Nov98               *
      *                 CSW009 *CREATE     Date 25FEB97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR782465 - SWIFT Alliance transfer failed on FTP subcommand. *
      *             Bank's Win FT Server's IIS has been upgraded      *
      *             from 6 to 7.5 and this allows more than one       *
      *             type of return code on ftp subcommands.           *
      *             This change allows more records in MSAFT3PD.      *
      *             (Child: AR877414)                                 *
      *           - Applied for AR1014318 (Child: AR1014319)          *
      *  247997 - Remove fix 191165. Fix 165212 is correct and there  *
      *           no miscoding. Apply fix 222779.                     *
      *  219242 - Not possible to create MT103+ payment msg from      *
      *           non-FT transaction (Recompile)                      *
      *  219241 - Defaulting of "Details of Charges" assign a         *
      *           system value (Recompile)                            *
      *  CSW027 - Midas Message Manager AFT interface                 *
      *  191165 - One line mis-coded in fix 165212                    *
      *  165212 - partially reverse 147256 and correct MSAFT3PD       *
      *  147256 - externalise FTP return codes                        *
      *  CSW009 - Midas-SWIFT Alliance Automated File Transfer        *
      *                                                               *
      *****************************************************************
      /EJECT
     FMSFTROPD  IF   E             disk    infsr(srfile)
     FMSFTRIPD  O    E             disk    infsr(srfile)
     FMSAFT3PD  IT   F   15        disk                                                       147256
      /EJECT
     D cpy@            S             80    dim(1) ctdata perrcd(1)
      ** Array containing Copyright statement
      *
     D*rtc******       S              3    dim(5) perrcd(5)                          147256 AR782465
     D**********                           fromfile(msaft3pd)                        147256 AR782465
     D rtc             S              3    dim(20) perrcd(5)                                AR782465
     D                                     fromfile(msaft3pd)                               AR782465
      ** Table of FTP expected return code(s)                                                 147256
     D/COPY WNCPYSRC,MS3250D001
      *
     D dssdy         E DS                  extname(DSSDY)
      ** Data Structures used by access objects
      *
     D DSFDY         E DS                  extname(DSFDY)                                     CSW027
      **  Short data structure for access programs                                            CSW027
      *                                                                                       CSW027
     D sdbank        E DS                  extname(SDBANKPD)
      ** Bank details ICD
      *
     D sdmgme        E DS                  extname(SDMGMEPD)
      ** Message Generation/Message Management ICD
      *
     D  sdstat       E DS                  extname(SDSTAT)
     Dren@mode       E                     extfld(MODE)
      ** SDSTAT for system prefix
      *
     D  w@mifil        DS
     D  w@pfx                  1      2
     D  w@fil                  3     24    inz('DPLIB/MSPCCIPD.MSPCCI.')
     D  w@nofiles             25     27  0
      ** Define Midas DOS-PCC input file for inclusion in FTP script
      *
     D                 DS
     D  SIFTPO                 1    128
     D  w@in4                  1      4
     D  w@in5                  1      5
      ** Analyse FTP output
      *
      /COPY MSCPYSRC,SRERRD
      /EJECT
      *****************************************************************
      *  Index to Subroutines                                         *
      *                                                               *
      *  sr_init       : Initialise program                           *
      *  sr_list       : Write to output file for FTP list operation  *
      *  sr_tfr        : Write to output file for FTP transfer        *
      *                  operation                                    *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Input parameter  : *LIST - create script for list
      **                    *TFR  - create script for transfer
      ** Output parameter : number of message files (*TFR only)
     C     *entry        plist
     C                   parm                    i@mode            5
     C                   parm                    o@nofiles         3 0
      *
      ** Set up copyright parameter
     C                   movea     cpy@          cpy2@            80
      *
      ** Initialise program
     C                   exsr      sr_init
      *
      ** Create script file for *LIST or *TFR mode
     C     i@mode        ifeq      '*LIST'
     C                   exsr      sr_list
     C                   else
     C                   exsr      sr_tfr
     C                   endif
      *
      ** Terminate
     C                   z-add     w@nofiles     o@nofiles
     C                   move      *on           *inlr
      /EJECT
      **********************************************************************
      * sr_list        : Write to output file for FTP list operation       *
      * -------                                                            *
      *                                                                    *
      * Called by      : mainline                                          *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_list       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_list'     @STK(Q)
      *
      ** Line 1: <User> <Password> (sign on to Alliance machine)
     C     ENSUSR        cat(p)    ENSPWD:1      SIFTPI
     C                   write     msftpid0
      *
      ** Line 2: CD <path name> (change directory)
     C     'CD'          cat(p)    ENSPHI:1      SIFTPI
     C                   write     msftpid0
      *
      ** Line 3: LS <filename pattern> (list files which match pattern)
     C     'LS'          cat(p)    ENSRFI:1      SIFTPI
     C                   write     msftpid0
      *
      ** Line 4: QUIT (end FTP session)
     C                   movel(p)  'QUIT'        SIFTPI
     C                   write     msftpid0
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_tfr         : Write to output file for FTP transfer operation   *
      * ------                                                             *
      *                                                                    *
      * Called by      : mainline                                          *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_tfr        begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_tfr'      @STK(Q)
      *
      ** Access output of list operation to get filenames
     C                   read      msftpod0                               55
     C     *in55         doweq     '0'
     C     w@in5         andne     w@ls
     C                   read      msftpod0                               55
     C                   enddo
      *
      ** If 'LS' operation not found perform database error processing
     C     *in55         ifeq      '1'
     C                   movel     'MSFTROPD'    w0file
     C                   movel(p)  'LS'          w0key
     C                   z-add     03            w0ernb
     C                   movel     'MEM5003'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   exsr      srerr
     C                   endif
      *
      ***Read*'200*PORT...'*****************************************************              147256
      ** Read '227 Entering Passive Mode...'                                                  147256
     C                   read      msftpod0                               55
      *
      ***Read*'150*Opening...'*if*files*found*or*'550...'*if*no*files*found*****              147256
      ** Read '125 Data connection....'                                                       147256
     C                   read      msftpod0                               55
      *
      ** Read again to check if files found                                                   147256
     C**********         read      msftpod0                               55            147256165212
      *                                                                                       147256
      ** If files found, build script
     C*****w@in4         ifeq      '150 '                                                     147256
     C*****w@in4         ifne      rtc(1)                                               147256165212
     C                   movel(p)  rtc(1)        wk4               4                          165212
     C*****w@in4         ifeq      wk4                                                  165212191165
     C*****w@in4         ifne      wk4                                                 191165 247997
      *                                                                                     AR782465
      ** check other records in MSAFT3PD for more possible return codes                     AR782465
      *                                                                                     AR782465
     C     w@in4         ifne      wk4                                                      AR782465
      *                                                                                     AR782465
      ** set array index to 6 (5 per line, so 6 is the 2nd line's 1st                       AR782465
      ** element)                                                                           AR782465
      *                                                                                     AR782465
     C                   z-add     6             Y                 2 0                      AR782465
     C                   exsr      sr_addval                                                AR782465
     C                   endif                                                              AR782465
      *                                                                                     AR782465
     C     w@in4         ifeq      wk4                                                        247997
      *
      ** Line 1: <User> <Password> (sign on to Alliance machine)
     C     ENSUSR        cat(p)    ENSPWD:1      SIFTPI
     C                   write     msftpid0
      *
      ** Line 2: NAMEFMT 1 (for IFS file system)                                              CSW027
      *                                                                                       CSW027
     C     CSW027        ifeq      'Y'                                                        CSW027
     C                   movel(p)  'NAMEFMT 1'   SIFTPI                                       CSW027
     C                   write     MSFTPID0                                                   CSW027
      *                                                                                       CSW027
      ** Line 3: LCD <path name> (change local directory)                                     CSW027
      *                                                                                       CSW027
     C     'LCD'         cat(p)    ENLPHI:1      SIFTPI                                       CSW027
     C                   write     MSFTPID0                                                   CSW027
     C                   endif                                                                CSW027
      *                                                                                       CSW027
      ** Line 2: TYPE I (for 'image' i.e. transfer file in binary form)
     C                   movel(p)  'TYPE I'      SIFTPI
     C                   write     msftpid0
      *
      ** Line 3: CD <path name> (change directory)
     C     'CD'          cat(p)    ENSPHI:1      SIFTPI
     C                   write     msftpid0
      *
      ** Line 4 onwards...
     C**************     read      msftpod0                               55                  147256
     C                   read      msftpod0                               55                  165212
     C                   movel(p)  rtc(2)        wk4                                          165212
      *                                                                                     AR782465
      ** check other records in MSAFT3PD for more possible return codes                     AR782465
      *                                                                                     AR782465
     C     w@in4         ifne      wk4                                                      AR782465
      *                                                                                     AR782465
      ** set array index to 7 (5 per line, so 7 is the 2nd line's 2nd                       AR782465
      ** element)                                                                           AR782465
      *                                                                                     AR782465
     C                   z-add     7             Y                                          AR782465
     C                   exsr      sr_addval                                                AR782465
     C                   endif                                                              AR782465
      *                                                                                     AR782465
     C     *in55         doweq     '0'
     C*****w@in4         andne     '226 '                                                     147256
     C*****w@in4         andne     rtc(2)                                               147256165212
     C     w@in4         andne     wk4                                                        165212
     C     w@nofiles     andlt     999
      *
      ** increment sequence number
     C                   add       1             w@nofiles
      *
     C     CSW027        ifeq      'Y'                                                        CSW027
     C     'GET'         cat(p)    SIFTPO:1      SIFTPI                                       CSW027
     C                   write     msftpid0                                                   CSW027
      *                                                                                       CSW027
      ** GET <filename> xxDPLIB/MSPCCIPD.MSPCCI.<seq. no.> (get file to mbr)
      *                                                                                       CSW027
     C                   else                                                                 CSW027
     C     'GET'         cat(p)    SIFTPO:1      SIFTPI
     C                   cat       w@mifil:1     SIFTPI
     C                   write     msftpid0
     C                   endif                                                                CSW027
     C/COPY WNCPYSRC,MS3250C001
      *
      ** DEL <filename> (delete file)
     C     'DEL'         cat(p)    SIFTPO:1      SIFTPI
     C                   write     msftpid0
     C/COPY WNCPYSRC,MS3250C002
      *
      ** Read next file name
     C                   read      msftpod0                               55
     C                   enddo
      *
      ** Line n: QUIT (end FTP session)
     C                   movel(p)  'QUIT'        SIFTPI
     C                   write     msftpid0
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************                AR782465
      * sr_addval      : Additional Validation of return codes             *                AR782465
      * -------          using more records in MSAFT3PD                    *                AR782465
      *                                                                    *                AR782465
      * Called by      : sr_check                                          *                AR782465
      *                                                                    *                AR782465
      * Calls          : -                                                 *                AR782465
      *                                                                    *                AR782465
      **********************************************************************                AR782465
      *                                                                                     AR782465
     C     sr_addval     begsr                                                              AR782465
      *                                                                                     AR782465
     C     y             dowle     20                                                       AR782465
     C     w@in4         andne     wk4                                                      AR782465
     C                   movel(p)  rtc(y)        wk4                                        AR782465
     C                   add       5             y                                          AR782465
     C                   enddo                                                              AR782465
      *                                                                                     AR782465
     C                   endsr                                                              AR782465
      /EJECT                                                                                AR782465
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
     C                   z-add     0             w@nofiles
      *
      ** Set prefix for FTP echo output ('>' for current versions of OS/400)
     C                   movel(p)  '>'           w@opfx            5
      *
      ** Initialise FTP subcommand 'LS' as it appears in FTP output
     C     w@opfx        cat(p)    'LS':1        w@ls              5
      *
      ** Define data areas
     C     *dtaara       define                  sdstat
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
     C                   exsr      srerr
     C                   endif
      *
      ** Is CSW027 installed?                                                                 CSW027
      *                                                                                       CSW027
     C                   CALL      'AOSARDR0'                                                 CSW027
     C                   PARM      '       '     @RTCD             7                          CSW027
     C                   PARM      '*VERIFY'     @OPTN             7                          CSW027
     C                   PARM      'CSW027'      @SARD             6                          CSW027
     C     @RTCD         IFNE      *BLANK                                                     CSW027
     C     @RTCD         ANDNE     '*NRF   '                                                  CSW027
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSW027
     C                   MOVEL     '022'         DBASE                                        CSW027
     C                   MOVEL     @RTCD         DBKEY                                        CSW027
     C                   SETON                                        U7U8                    CSW027
     C                   EXSR      *PSSR                                                      CSW027
     C                   ENDIF                                                                CSW027
     C     @RTCD         IFEQ      *BLANK                                                     CSW027
     C                   MOVE      'Y'           CSW027            1                          CSW027
     C                   ENDIF                                                                CSW027
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
(c) Misys International Banking Systems Ltd. 2001
