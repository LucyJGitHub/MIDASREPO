     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  ALWNULL(*USRCTL)                                             *
/*EXI *  TEXT('Midas ME Purge Incoming MX Msgs - phase 1/2')          *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME2210 - Purge Incoming MX Transactions - Phase 1 of 2       *
      *                                                               *
      *  Function:  This program checks if an Incoming Message has    *
      *  passed it's retention period. If it has, the message details *
      *  are added to the Purge file.                                 *
      *                                                               *
      *  Called By: MEC2220 - Incoming MX Message Purge Phase 1 of 2  *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. CSW122  *CREATE    Date 14Apr23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW122 - SWIFT ISO20022 Changes                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ~~~~~~~~~~~~~~~                                              *
      *                                                               *
      *  50    First cycle                                            *
      *  60    MX-MT Join file EOF indicator                          *
      *  80    ME-MX Join file EOF indicator                          *
      *  90    ME ICD call result                                     *
      *  99    Indicator to use MDY format on date conversion         *
      *  99    Message processed indicator                            *
      *                                                               *
      *  LR    End program                                            *
      *                                                               *
      *****************************************************************
      /EJECT

      ** Incoming MX Message file - joined with MSIXISOPD + MEISOMPD

     FMEMXINFTJ1IF   E           K DISK    infsr(SRFILE)

      ** Incoming MX Message file - joined with MSIXISOPD + MEISOMPD

     FMEMXMTJ1  IF   E           K DISK    infsr(SRFILE)

      ** Incoming MX Message Purge File

     FMEMXINRMPDO  A E           K DISK    infsr(SRFILE)
      /EJECT

      **  /Copy point for Array Declarations

      /COPY ZSRSRC,ZDATE2Z1LE

      ** /Copy point for error processing declarations

      /COPY MECPYSRC,SRERRELE
      /COPY MECPYSRC,SRERRILE
      /EJECT

      ** Array containing Copyright statement

     D cpy@            S             80    dim(1) ctdata perrcd(1)

      ** RUNDAT data area

     D RUNDTA        E DS                  extname(RUNDAT)

      ** Message Management ICD data structure parameter

     D SDMGME        E DS                  extname(SDMGMEPD)

      ** Access object data structure

     D DSFDY         E DS                  extname(DSFDY)

      ** Working field for value date

     D  W@SVDT         S              6A

      ** Purge date based on received date

     D  WKDATE         S              5S 0

      ** Fields for date manipulation

     D  WMMDD          S              4S 0
     D  WYY            S              2S 0
     D  WNDAT          S              6A
     D  WKVDAT         S              5S 0

      ** Working field for message type

     D  WMTYP          S             20A

      ** Working field for message id

     D  w@msgid        S             20A
      /EJECT
      *****************************************************************
      *  Index to Subroutines                                         *
      *                                                               *
      *  sr_init       : Initialise program                           *
      *  sr_purge      : Check for purgeable messages                 *
      *  sr_write      : Write records on purge file                  *
      *  srerr         : Error processing (on copysource)             *
      *  zdate1        : Date conversion (on copysource)              *
      *                                                               *
      *****************************************************************
      /EJECT

      ** Set up copyright statement

     C                   movea     cpy@          bis@             80

      **  Set up subroutine stack name

     C                   add       1             Q
     C                   movel     'main'        @STK(Q)

      **  Define entry parameters

     C     *entry        plist
     C                   parm                    w0rtn             7

      ** Push routine

     C                   z-add     1             Q
     C                   movel     'mainline'    @STK(Q)

      ** Initialise program

     C     *in50         ifeq      '0'
     C                   exsr      sr_init
     C                   endif

      ** Determine if messages may be purged

     C                   exsr      sr_purge

      ** Unwind subroutine stack name

     C                   clear                   @STK(Q)
     C                   sub       1             Q
      *
     C                   seton                                        LR
      /EJECT

      **********************************************************************
      * sr_purge       : Check if message may be purged                    *
      * --------                                                           *
      *                                                                    *
      * Called by      : main                                              *
      *                                                                    *
      * Calls          :                                                   *
      *                                                                    *
      **********************************************************************

     C     sr_purge      begsr

      ** Set up subroutine stack name

     C                   add       1             Q
     C                   movel     'sr_purge'    @STK(Q)

      ** Access the MX Index and ME Header join file to check for available records.

     C                   read      MEMXINFTJ1                             80
     C                   dow       *in80 = *off

      ** Move the message id to the working field

     C                   eval      w@msgid = %trim(IMXID)

      ** Convert SVDT from MEMXINFTJ1 to YYMMDD format

     C
     C                   eval      W@SVDT = %subst(SVDT:3:2)
     C                             + %subst(SVDT:6:2)
     C                             + %subst(SVDT:9:2)

      ** Get the message received date from MEMXINFTJ1
      ** Add the number of retention days to get the purge date

     C     OMCDTE        add       ENDSMN        WKDATE

      ** Compute for the message value date

     C                   move      W@SVDT        WMMDD
     C                   movel     W@SVDT        WYY
     C                   move      WYY           WNDAT
     C                   movel     WMMDD         WNDAT
     C                   move      WNDAT         ZDATE
     C                   move      '1'           *in98
     C                   exsr      ZDATE1
     C                   z-add     ZDAYNO        WKVDAT
     C                   movel     IMTPY         WMTYP

      ** Purge incoming MX messages if both the value date and the purge date has passed

     C     WKDATE        ifle      WURDNB
     C     WKVDAT        andle     WURDNB

      ** Check the join file if the message has already been processed

     C     IMPF          ifeq      'Y'
     C                   seton                                        99
     C                   else
     C                   setoff                                       99
     C                   endif

      ** If message has been processed, continue the purge analysis
     C     *in99         ifeq      '1'

      ** If the message type is non FT, proceed with the purge

     C                   if        %trim(%subst(IMTPY:1:4)) = 'camt'
     C                   exsr      sr_write
     C                   else

      ** Else check MX MT Joined file if the MsgId and UETR combination exists

     C     MXMTKL        klist
     C                   kfld                    w@msgid
     C                   kfld                    IUETR
      *
     C     MXMTKL        setll     MEMXMTJ1
     C     MXMTKL        reade     MEMXMTJ1                               60

      ** If record is found, do not proceed with the purge
      ** This means that the record still exists on the core MT files

     C     *in60         ifne      '0'
     C                   exsr      sr_write
     C                   endif
      *
     C                   endif
     C                   endif
     C                   endif

      ** Read next record from the join file and continue until end of file

     C                   read      MEMXINFTJ1                             80
      *
     C                   enddo

      ** Unwind subroutine stack name

     C                   clear                   @STK(Q)
     C                   sub       1             Q
      *
     C                   endsr
      /EJECT

      **********************************************************************
      * sr_write       : Check if message may be purged                    *
      * --------                                                           *
      *                                                                    *
      * Called by      : main                                              *
      *                                                                    *
      * Calls          :                                                   *
      *                                                                    *
      **********************************************************************

     C     sr_write      begsr

      ** Set up subroutine stack name

     C                   add       1             Q                 5 0
     C                   movel     'sr_write'    @STK(Q)

      ** Build the details to be written on the purge file

     C                   movel     IMXID         RMMXID                         Msg Id
     C                   movel     IUETR         RMUETR                         UETR
     C                   movel     ##JOB         RMAJOB                         Job Name
     C                   movel     ##USR         RMAUSR                         User Name
     C                   time                    RMATIM                         Action Time
     C                   movel     AGMRDT        RMARDT                         Action Date
     C                   movel     'I'           RMAACT                         Action Type
     C                   z-add     AGRDNB        RMRDNB                         Run Day No.

      ** Write the record on the purge file

     C                   write     @INRMPD

      ** Unwind subroutine stack name

     C                   clear                   @STK(Q)
     C                   sub       1             Q
      *
     C                   endsr
      /EJECT

      **********************************************************************
      *                                                                    *
      *  sr_init  : Initialise and define fields                           *
      *                                                                    *
      *  Called by: main                                                   *
      *                                                                    *
      *  Calls    : srerr  - Error Processing                              *
      *                                                                    *
      **********************************************************************

     C     sr_init       begsr

      ** Set up subroutine stack name

     C                   add       1             Q                 5 0
     C                   movel     'sr_init'     @STK(Q)

      ** Get Rundate information

     C     *DTAARA       define    RUNDAT        RUNDTA
     C                   in        RUNDTA
     C                   move      AGMRDT        wumrdt            7            Midas Run date
     C                   move      AGRDNB        wurdnb            5 0          Run day number
     C                   move      AGSUC         wusuc             1            Set up complete
     C                   move      AGDFF         wudff             1            Date Format
     C                   move      AGMBIN        wumbin            1            Multi Branched

      ** Get Retention Days for Message Management Module

     C                   call      'AOMGMER0'                           90
     C                   parm      *BLANKS       @rtcd             7
     C                   parm      '*FIRST '     @optn             7
     C     SDMGME        parm      SDMGME        dsfdy

      ** If return with an error (LR seton in called program) then
      ** process for database error.

     C     *in90         ifeq      '1'
     C     @rtcd         oreq      '*ERROR*'
     C                   movel     'AOMGMER0'    w0file
     C                   movel     '*CALL'       w0key                          ***************
     C                   z-add     1             w0ernb                         * DB ERROR 01 *
     C                   movel     'MEM5003'     w0msgd                         ***************
     C                   movel     'MIDAS  '     w0msgf
     C                   exsr      srerr
     C                   endif

      ** If purge period is 0 set to 1.

     C     ENDSMN        ifle      0
     C                   z-add     1             ENDSMN
     C                   endif

      ** Indicate that set up is complete

     C                   seton                                        50

      ** Unwind subroutine stack name

     C                   clear                   @STK(Q)
     C                   sub       1             Q
      *
     C                   endsr
      /EJECT

      ** /Copy point for Date Calculations

      /COPY ZSRSRC,ZDATE1Z2LE
      /EJECT

      ** File and Program Error Processing

      /COPY MECPYSRC,SRERRCLE
      /EJECT

      ** /Copy point for Arrays

      /COPY ZSRSRC,ZDATE2Z3
**  cpy@ table
(c) Finastra International Limited 2023
