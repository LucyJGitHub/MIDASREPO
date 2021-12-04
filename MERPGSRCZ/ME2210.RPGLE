     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
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
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. CSW122  *CREATE    Date 04Oct21               *
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
      *  90    Chain fail                                             *
      *  99    EOF on Read                                            *
      *                                                               *
      *  U7/U8 Error Ocurred                                          *
      *  LR    End program                                            *
      *                                                               *
      *****************************************************************
      /EJECT

      ** Incoming MX Message file - joined with MSIXISOPD + MEISOMPD

     FMEMXINFTJ1IF   E           K DISK    infsr(SRFILE)

      ** Incoming MX Message Purge File

     FMEMXINRMPDO  A E           K DISK    INFSR(SRFILE)
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

     D RUNDTA        E DS                  EXTNAME(RUNDAT)

      ** Message Management ICD data structure parameter

     D SDMGME        E DS                  EXTNAME(SDMGMEPD)

      ** Access object data structure

     D DSFDY         E DS                  EXTNAME(DSFDY)

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
      /EJECT
      *****************************************************************
      *  Index to Subroutines                                         *
      *                                                               *
      *  sr_init       : Initialise program                           *
      *  sr_purge      : Check for purgeable messages                 *
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

     C                   READ      MEMXINFTJ1                             80
     C                   dow       *in80 = *off

      ** Convert SVDT from MEMXINFTJ1 to YYMMDD format

     C
     C                   eval      W@SVDT = %subst(SVDT:3:2)
     C                             + %subst(SVDT:6:2)
     C                             + %subst(SVDT:9:2)

      ** Get the message received date from MEMXINFTJ1
      ** Add the number of retention days to get the purge date

     C     OMCDTE        ADD       ENDSMN        WKDATE

      ** Compute for the message value date

     C                   move      W@SVDT        WMMDD
     C                   movel     W@SVDT        WYY
     C                   move      WYY           WNDAT
     C                   movel     WMMDD         WNDAT
     C                   move      WNDAT         ZDATE
     C                   move      '1'           *in98
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        WKVDAT
     C                   movel     IMTPY         WMTYP

      ** Purge incoming MX messages if both the value date and the purge date has passed

     C     WKDATE        IFLE      WURDNB
     C     WKVDAT        ANDLE     WURDNB

      ** Build the details to be written on the purge file

     C                   MOVEL     IMXID         RMMXID                         Msg Id
     C                   MOVEL     IUETR         RMUETR                         UETR
     C                   MOVEL     ##JOB         RMAJOB                         Job Name
     C                   MOVEL     ##USR         RMAUSR                         User Name
     C                   TIME                    RMATIM                         Action Time
     C                   MOVEL     AGMRDT        RMARDT                         Action Date
     C                   MOVEL     'I'           RMAACT                         Action Type
     C                   Z-ADD     AGRDNB        RMRDNB                         Run Day No.

      ** Write the record on the purge file

     C                   WRITE     @INRMPD
      *
     C                   ENDIF

      ** Read next record from the join file and continue until end of file

     C                   READ      MEMXINFTJ1                             80
      *
     C                   enddo

      ** Unwind subroutine stack name

     C                   clear                   @STK(Q)
     C                   sub       1             Q
      *
     C                   endsr
      /EJECT
      *****************************************************************
      *                                                               *
      *  sr_init  : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: main                                              *
      *                                                               *
      *  CALLS    : srerr  - Error Processing                         *
      *                                                               *
      *****************************************************************

     C     sr_init       begsr

      ** Set up subroutine stack name

     C                   add       1             Q                 5 0
     C                   movel     'sr_init'     @STK(Q)

      ** Open Files

     C*                  OPEN      MEINRMPD
     C*                  OPEN      MEINFTJ1

      ** Get Rundate information

     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        wumrdt            7            Midas Run date
     C                   MOVE      AGRDNB        wurdnb            5 0          Run day number
     C                   MOVE      AGSUC         wusuc             1            Set up complete
     C                   MOVE      AGDFF         wudff             1            Date Format
     C                   MOVE      AGMBIN        wumbin            1            Multi Branched

      ** Get Retention Days for Message Management Module

     C                   CALL      'AOMGMER0'                           90
     C                   PARM      *BLANKS       @rtcd             7
     C                   PARM      '*FIRST '     @optn             7
     C     SDMGME        PARM      SDMGME        dsfdy

      ** If return with an error (LR seton in called program) then
      ** process for database error.

     C     *in90         ifeq      '1'
     C     @rtcd         oreq      '*ERROR*'
     C                   movel     'AOMGMER0'    w0file
     C                   movel     '*CALL'       w0key                          ***************
     C                   z-add     1             w0ernb                         * DB ERROR 04 *
     C                   movel     'MEM5003'     w0msgd                         ***************
     C                   movel     'MIDAS  '     w0msgf
     C                   exsr      srerr
     C                   endif

      ** If purge period is 0 set to 1.

     C     ENDSMN        ifle      0
     C                   Z-ADD     1             ENDSMN
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
      /EJECT
**  cpy@ table
(c) Finastra International Limited 2021
