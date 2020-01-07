     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD create o/g messages in DOS-PCC format')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD3200 - Create outgoing message file in DOS-PCC format      *
      *                                                               *
      *  Function:  This program reads all Ready-to-Send SWIFT        *
      *             messages and outputs them in SWIFT II DOS-PCC     *
      *             format for FTP transfer to SWIFT Alliance. It     *
      *             also creates the FTP script for the transfer.     *
      *                                                               *
      *  Called By: SDC3200 - FTP automated transmission              *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD053437  *CREATE  Date 07Oct19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053437 - CGL013 FTP exit program                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Notes:                                                       *
      *  ------                                                       *
      *                                                               *
      *  1. Formatted SWIFT messages are converted to ASCII for       *
      *     processing by FTP.FTP's standard conversion is not        *
      *     used because it doesn't convert CrLf correctly. The FTP   *
      *     file transfer type 'I' (image) is specified in the FTP    *
      *     script file to prevent further conversion.                *
      *                                                               *
      *  2. The FTP script transfers the messages to a file on        *
      *     FTP named #<filename>.nnn which is subsequently           *
      *     renamed to <filename>.nnn. FTP should be set up to        *
      *     ignore filenames beginning '#' on the Message Partner     *
      *     definition. This is to prevent FTP accessing an           *
      *     incomplete file.                                          *
      *                                                               *
      *****************************************************************

     FMGOREFM1  UF   E           K DISK    INFSR(SRFILE)
     FMGOMSGPD  IF   E           K DISK    INFSR(SRFILE)
     FSDPCCOPD  O    E             DISK    INFSR(SRFILE)
     FSDFTTIPD  O    E             DISK    INFSR(SRFILE)
     FSD3200AU  O    E             PRINTER OFLIND(*IN66) USROPN

      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement

     D TAB1            S              5A   CTDATA PERRCD(1) DIM(3)

     D Password        S            128
     D PReturnCode     S              7A
     D PAction         S              1A
     D PValidList      S             10A   INZ('SDINTFVL')
     D PLibrary        S             10A
     D PIDName         S            100A
     D PPass1          S            128A
     D PDescr          S           1000A
      ** Table containing valid Block 3 Codes

     D DSSDY         E DS                  extname(DSSDY)
      ** Data Structures used by access objects
      *
     D sdbank        E DS                  extname(SDBANKPD)
      ** Bank details ICD
      *
     D  msstat3      E DS                  extname(MSSTAT3)
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
     D  w@fil                  3     25    inz('DPLIB/SDPCCOPD.SDPCCOPD')
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
      *  SR_INIT       : Initialise program                           *
      *  SR_DETAIL     : Detail processing                            *
      *  SR_FORMAT     : Format message for transmission              *
      *  SR_WRITE      : Write to output file for FTP transfer        *
      *  SR_FTP        : Create FTP script file for transfer          *
      *                                                               *
      *****************************************************************

      ** Output parameter: o@msgs = 'Y' if any messages found, else 'N'
     C     *ENTRY        PLIST
     C                   PARM                    o@msgs            1
     C                   PARM                    EDRFNP           10
     C                   PARM                    EDRPNM           50
     C                   PARM                    EDSUID           10
     C                   PARM                    EDM940            1
     C                   PARM                    EDM941            1
     C                   PARM                    EDM942            1
     C                   PARM                    EDM950            1
     C                   PARM                    EDNWRK            6

      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@            80

      ** Initialise program
     C                   EXSR      SR_INIT

      ** Access ready-to-send messages and write to file
     C                   EXSR      SR_DETAIL

      ** If any messages output prepare FTP script file for transmission
      ** else write 'no details to report' to audit
     C     o@msgs        IFEQ      'Y'
     C                   EXSR      SR_FTP
     C                   WRITE     SD3200F4
     C                   WRITE     SD3200F6
     C                   ENDIF

      ** Terminate
     C                   MOVE      *ON           *INLR

      **********************************************************************
      /EJECT
      **********************************************************************
      * SR_DETAIL      : Detail processing: access messages and write      *
      * ---------        to transfer file                                  *
      *                                                                    *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : SR_FORMAT                                         *
      *                  SR_WRITE                                          *
      *                                                                    *
      **********************************************************************

     C     SR_DETAIL     BEGSR

      ** Push subroutine
     C                   ADD       1             Q
     C                   MOVEL     'SR_DETAIL'   @STK(Q)

      ** Read first ready-to-send message
     C     *LOVAL        SETLL     MGOREFD0
     C                   READ      MGOREFD0                               50

      ** For each message...
     C     *IN50         DOWEQ     '0'

     C                   IF        (EDM940 = 'Y' AND MTPY = '940') OR
     C                             (EDM941 = 'Y' AND MTPY = '941') OR
     C                             (EDM942 = 'Y' AND MTPY = '942') OR
     C                             (EDM950 = 'Y' AND MTPY = '950')

      ** Set flag for messages found
     C     *IN50         IFEQ      '0'
     C                   MOVEL     'Y'           o@msgs
     C                   ENDIF

      ** Create SWIFT II DOS-PCC format
     C                   EXSR      SR_FORMAT

      ** Write to output file for FTP transfer
     C                   EXSR      SR_WRITE

      ** Update status to PEND/ing Transmission
     C                   MOVEL     'PEND'        MGST
     C                   UPDATE    MGOREFD0

      ** Write details to audit
     C     *IN66         IFEQ      *ON
     C                   MOVEL     *OFF          *IN66
     C                   IF        w#auopen = '0'
     C                   OPEN      SD3200AU
     C                   MOVE      '1'           w#auopen
     C                   ENDIF
     C                   WRITE     SD3200F1
     C                   ENDIF
     C                   WRITE     SD3200F2

     C                   ENDIF

     C                   READ      MGOREFD0                               50
     C                   ENDDO

      ** Pop subroutine
     C                   CLEAR                   @STK(Q)
     C                   SUB       1             Q
     C                   ENDSR

      **********************************************************************
      /EJECT
      **********************************************************************
      * SR_FORMAT      : Format message for transmission                   *
      * ---------                                                          *
      *                                                                    *
      * Called by      : SR_DETAIL                                         *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************

     C     SR_FORMAT     BEGSR

      ** Push subroutine
     C                   ADD       1             Q
     C                   MOVEL     'SR_FORMAT'   @STK(Q)

      ** Access first data record which is not part-deleted
     C     TRNO          SETLL     MGOMSGD0
     C     PTDL          DOUNE     'D'
     C     *IN15         OREQ      *ON
     C     TRNO          READE     MGOMSGD0                               15
     C                   ENDDO

      ** Database error if no live details found
     C     *IN15         IFEQ      *ON
     C                   MOVEL     'MGOMSGPD'    w0file
     C                   MOVEL(P)  TRNO          w0key
     C                   Z-ADD     03            w0ernb
     C                   MOVEL     'MEM5004'     w0msgd
     C                   MOVEL     'MIDAS  '     w0msgf
     C                   IF        w#auopen = '0'
     C                   OPEN      SD3200AU
     C                   MOVE      '1'           w#auopen
     C                   ENDIF
     C                   WRITE     SD3200F1
     C                   WRITE     SD3200F5
     C                   EXSR      SRERR
     C                   ELSE

      ** Set 'Start-of-Message'
     C                   CLEAR                   w@msgbuf
     C                   MOVEA     w@soh         w@msgbuf(1)

      ** Expand destination address to 12 characters with 'X' between
      ** BIC and branch code, and branch code 'XXX' if not quoted.
     C                   MOVEL(P)  NWDS          w@nwds
     C     w@dbrch       IFEQ      *BLANKS
     C                   MOVEL     'XXX'         w@dbrch
     C                   ENDIF
     C                   MOVEL(P)  w@dbic        @dst2
     C     @dst2         CAT       'X':0         @dst2
     C     @dst2         CAT       w@dbrch:0     @dst2

      ** Set up sender's address and write SWIFT II header to message buffer
     C                   MOVEL     NWSN          @snd2
     C                   Z-ADD     2             A                 5 0
     C                   MOVEA     @sw2          w@msgbuf(A)
     C                   ADD       49            A

      ** Write delivery notification to message buffer if not blank,
      ** followed by end of block 2, start of block 4.
     C     DELC          IFNE      '0'
     C     DELC          ANDNE     ' '
     C                   MOVEA     DELC          w@msgbuf(A)
     C                   ADD       1             A
     C                   ENDIF

      ** Add processing for block 3
     C     MTAG          IFEQ      '3:   '

      ** add to data structure
      ** end block 2
     C                   MOVEA     '}{3:'        w@msgbuf(A)
     C                   ADD       4             A

      ** format start block 3
     C     ')(':'}{'     XLATE     MFLD          MFLD

      ** add data for block 3
     C     ' '           CHECKR    MFLD          B
     C                   MOVEA     MFLD          w@msgbuf(A)
     C                   ADD       B             A

      ** end block 3
     C                   MOVEA     '}'           w@msgbuf(A)
     C                   ADD       1             A

      ** Read next record
     C     TRNO          READE     MGOMSGD0                               15
     C                   ENDIF

      ** Output all Block 3 details first before Block 4
     C     *IN15         IFEQ      *OFF

     C     MTAG          LOOKUP    TAB1                                   17

     C     *IN17         IFEQ      *ON

     C                   MOVEA     w@txt4        w@msgbuf(A)
     C                   ADD       4             A

     C     *IN15         DOWEQ     *OFF
     C     *IN17         ANDEQ     *ON

     C                   MOVEL     MTAG          WBLK3             5
     C                   MOVEL     '{'           WBLK3
     C                   MOVEA     WBLK3         w@msgbuf(A)
     C                   ADD       5             A

     C                   MOVEA     MFLD          w@msgbuf(A)
     C     w@msgbuf(A)   DOWNE     *BLANK
     C                   ADD       1             A
     C                   ENDDO
     C                   MOVEA     '}'           w@msgbuf(A)
     C                   ADD       1             A

     C     PTDL          DOUNE     'D'
     C     *IN15         OREQ      *ON
     C     TRNO          READE     MGOMSGD0                               15
     C                   ENDDO
     C     *IN15         IFEQ      *OFF
     C     MTAG          LOOKUP    TAB1                                   17
     C                   ENDIF

     C                   ENDDO

     C                   ENDIF

     C                   ENDIF

      ** Output Block 4 for remaining records
     C                   MOVEA     txt3          w@msgbuf(A)
     C                   ADD       6             A

      ** Process remaining records
     C     *IN15         DOWEQ     *OFF

      ** Set up message data in buffer
     C     ' '           CHECKR    MTAG          B                 5 0
     C                   MOVEA     MTAG          w@msgbuf(A)
     C                   ADD       B             A

     C     ' '           CHECKR    MFLD          B

      ** Add a blank character to the position 50 to avoid skipping.
     C     B             IFEQ      49
     C     CTRC          ANDEQ     *BLANKS
     C                   ADD       1             B
     C                   ENDIF

     C                   MOVEA     MFLD          w@msgbuf(A)
     C                   ADD       B             A

     C     ' '           CHECKR    CTRC          B
     C                   MOVEA     CTRC          w@msgbuf(A)
     C                   ADD       B             A

      ** Read outgoing message file but ignore deleted parts
     C     PTDL          DOUNE     'D'
     C     *IN15         OREQ      *ON
     C     TRNO          READE     MGOMSGD0                               15
     C                   ENDDO

     C                   ENDDO

      ** Append end of text block 4
     C                   MOVEA     '-}'          w@msgbuf(A)
     C                   ADD       2             A

      ** Append TNG (training) and PDE (Possible Duplicate Emission)
      ** trailers in block {5: if required
     C     @tandt        IFEQ      '0'
     C     MPDE          OREQ      'Y'
     C                   MOVEA     '{5:'         w@msgbuf(A)
     C                   ADD       3             A

      ** TNG required if sender's address is Test and Training (identified
      ** by '0' in position 8)
     C     @tandt        IFEQ      '0'
     C                   MOVEA     '{TNG:}'      w@msgbuf(A)
     C                   ADD       6             A
     C                   ENDIF

      ** If PDE requested add {PDE:} field
     C     MPDE          IFEQ      'Y'
     C                   MOVEA     '{PDE:}'      w@msgbuf(A)
     C                   ADD       6             A
     C                   ENDIF

      ** Add final closing }
     C                   MOVEA     '}'           w@msgbuf(A)
     C                   ADD       1             A
     C                   ENDIF

      ** Add End-of-Text
     C                   MOVEA     w@etx         w@msgbuf(A)

     C                   ENDIF

      ** Pop subroutine
     C                   CLEAR                   @STK(Q)
     C                   SUB       1             Q
     C                   ENDSR

      **********************************************************************
      /EJECT
      **********************************************************************
      * SR_WRITE       : Write to output file for FTP transfer             *
      * --------                                                           *
      *                                                                    *
      * Called by      : sr_detail                                         *
      *                                                                    *
      * Calls          : API: QDCXLATE (character set conversion)          *
      *                                                                    *
      **********************************************************************

     C     SR_WRITE      BEGSR

      ** Push subroutine
     C                   ADD       1             Q
     C                   MOVEL     'SR_WRITE'    @STK(Q)

      ** Convert from EBCDIC to ASCII and write to output file
     C                   Z-ADD     1             X                 5 0

     C     w@msgout(X)   DOWNE     *BLANKS

     C                   CALL      'QDCXLATE'
     C                   PARM      512           p@lngth           5 0
     C                   PARM      w@msgout(X)   p@buf           512
     C                   PARM      'QTCPASC'     p@tblin          10
     C                   PARM      'QUSRSYS'     p@libin          10

     C                   MOVEL(P)  p@buf         SIDATA
     C                   WRITE     SDPCCOD0
     C                   ADD       1             X
     C                   ENDDO

      ** Pop subroutine
     C                   CLEAR                   @STK(Q)
     C                   SUB       1             Q
     C                   ENDSR

      **********************************************************************
      /EJECT
      **********************************************************************
      * SR_FTP         : Create FTP script file for transfer               *
      * ------                                                             *
      *                                                                    *
      * Called by      : mainline                                          *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************

     C     SR_FTP        BEGSR

      ** Push subroutine
     C                   ADD       1             Q
     C                   MOVEL     'SR_FTP'      @STK(Q)

      ** Create remote filename in form <filename>.nnn where 'nnn' is a
      ** a sequence number from dtaara/msstat2. Also create version with
      ** # prefix: #<filename>.nnn. Increment sequence for each new file.
     C     *LOCK         IN        MSSTAT3
     C                   MOVEL     SICSEQ        w@seqa
     C     w@seqa        IFEQ      *BLANKS
     C     w@seqa        OREQ      '000'
     C                   Z-ADD     1             w@seqn
     C                   ELSE
     C                   ADD       1             w@seqn
     C                   ENDIF
     C                   MOVE      w@seqa        SICSEQ
     C                   OUT       msstat3

     C     EDRFNP        CAT       '.':0         w@alfil          30
     C                   CAT       w@seqa:0      w@alfil
     C     '#'           CAT       w@alfil:0     w@#alfil         31

      ** Line 1: <User> <Password> (sign on to FTP machine)
      ** Check User ID if exists, then retrieve the password.

     C                   EVAL      Password = *Blanks

     C                   IF        EDSUID <> *BLANKS
     C                   EVAL      PLibrary = LIBR + 'DMLIB'
     C                   EVAL      PIDName = 'NETWORK_' + EDNWRK

     C                   CALL      'SD000404'
     C                   PARM      *Blanks       PReturnCode
     C                   PARM      'F'           PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM                    PIDName
     C                   PARM      *Blanks       PPass1
     C                   PARM      *Blanks       PDescr

     C                   IF        PReturnCode = *Blanks
     C                   EVAL      Password = PPass1
     C                   ENDIF
     C                   ENDIF

     C     EDSUID        CAT(P)    Password:1    SIFTPI

     C                   WRITE     SDFTPID0

      ** Line 2: TYPE I (for 'image' i.e. transfer file in binary form)
     C                   MOVEL(P)  'TYPE I'      SIFTPI
     C                   WRITE     SDFTPID0

      ** Line 3: CD <path name> (change directory)
     C     'CD'          CAT(P)    EDRPNM:1      SIFTPI
     C                   WRITE     SDFTPID0

      ** Line 4: PUT <Midas file> #<Alliance file> (transfer file)
     C     'PUT'         CAT(P)    w@mifil:1     SIFTPI
     C                   CAT       w@#alfil:1    SIFTPI
     C                   WRITE     SDFTPID0

      ** Line 5: REN #<Alliance file> <Alliance file> (rename: see note 2)
     C     'REN'         CAT(P)    w@#alfil:1    SIFTPI
     C                   CAT       w@alfil:1     SIFTPI
     C                   WRITE     SDFTPID0

      ** Line 6: QUIT (end FTP session)
     C                   MOVEL(P)  'QUIT'        SIFTPI
     C                   WRITE     SDFTPID0

      ** Pop subroutine
     C                   CLEAR                   @STK(Q)
     C                   SUB       1             Q
     C                   ENDSR

      **********************************************************************
      /EJECT
      **********************************************************************
      * SR_INIT        : Initialise program                                *
      * -------                                                            *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************

     C     SR_INIT       BEGSR

      ** Push subroutine
     C                   ADD       1             Q
     C                   MOVEL     'SR_INIT'     @STK(Q)

      ** Initialise output parameter
     C                   MOVEL     'N'           o@msgs

      ** Define all data areas
     C     *DTAARA       DEFINE                  SDSTAT
     C     *DTAARA       DEFINE                  MSSTAT3

      ** Access system prefix
     C                   IN        SDSTAT
     C                   MOVEL     LIBR          w@pfx

      ** Access bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       p@rtcd            7
     C                   PARM      '*FIRST'      p@optn            7
     C     SDBANK        PARM      *BLANKS       DSSDY

      ** If the Access Object returns an error code, database error
     C     p@rtcd        IFNE      *BLANK
     C                   MOVEL     'AOBANKR0'    w0file
     C                   MOVEL     'Bank details'w0key
     C                   Z-ADD     01            w0ernb
     C                   MOVEL     'MEM5003'     w0msgd
     C                   MOVEL     'MIDAS  '     w0msgf
     C                   OPEN      SD3200AU                                                   233575
     C                   WRITE     SD3200F1
     C                   WRITE     SD3200F5
     C                   EXSR      SRERR
     C                   ENDIF

      ** Write audit report headings
     C                   MOVE      *ON           *IN66                                        233575
     C                   MOVE      '0'           w#auopen          1                          233575

      ** Pop subroutine
     C                   CLEAR                   @STK(Q)
     C                   SUB       1             Q
     C                   ENDSR

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
      *****************************************************************

     C     *PSSR         BEGSR

     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP

     C                   CALL      'DBERRCTL'

     C                   ENDIF

     C                   SETON                                        U7U8LR
     C                   RETURN

     C                   ENDSR

      ********************************************************************
      /COPY MSCPYSRC,SRERRC
**  CPY@
(c) Finastra International Limited 2019
** TAB1
:103:
:119:
:121:
