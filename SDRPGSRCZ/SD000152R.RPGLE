     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Nostro Account Activity Report ')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000152R - Nostro Account Activity Report                   *
      *                                                               *
      *  Function: This program generate report that list all         *
      *  (I/C Int) transactions associated with the Nostro Account    *
      *                                                               *
      *  (c) Finastra International Limited. 2017                     *
      *                                                               *
      *  Last Amend No. MD-38440 *Create   Date 27Oct17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD038440 - Nostro deletion issue. Generate report            *
      *             to display transactions of a Nostro accnt.        *
      *                                                               *
      *****************************************************************
      *
     FSD000152DFCF   E             WORKSTN
     FSDNOSTL1  IF   E           K DISK
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  DSPSCN  -  Display Screen                                    *
      *  VALID   -  Validate Input                                    *
      *  ZASNMS  -  Send message to program message queue             *
      *  MSGSUB  -  Set up message subfile                            *
      *                                                               *
      *****************************************************************
      /SPACE 3
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D PSEQ            S              5
     D PLEV            S              1
     D PENTY           S              3
      /SPACE 3
     D RUNDAT        E DS
      *
      **  Run Date DS
      *
     D PSDS           SDS
      *
      **  Program Status DS
      *
     D  JOB                  244    253
     D  SWSID                244    253
     D  SUSER                254    263
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      **  First DS for access programs, Short Data Structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Access Object Data Structure
      *
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
      ** Local Data Area Data Structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details Data Structure
     D PARM            DS
     D  PMODE                  1      1
     D  A7BRCD                 2      4
     D  A7CUST                 5     10
     D  A7CYCD                11     13
     D  A7ACCD                14     23
     D  ##ACSN                24     25
     D  A7NONB                26     27
     D  RETURN                28     28

     C/EJECT
      *================================================================
      *  P R O G R A M     S T A R T                                  *
      *================================================================
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ              5
     C                   PARM                    PLVL              1
     C                   PARM                    PETY              3
     C                   PARM                    PARM
     C                   PARM                    PACT              1
     C                   PARM                    PCMD              1
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      **  In the Dataarea RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      ** Access bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = @OPTN
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **  Move run date (alpha) to screen field for display
      *
     C                   MOVEL     AGMRDT        SRUNA
      *
     C     KNostro       KLIST
     C                   KFLD                    NoCcy             3
     C                   KFLD                    NoNum             2
      **  Set up message subfile
      *
     C                   EXSR      MSGSUB
      *
      **  Validate input and display screen until F3 pressed
      *
     C                   EXSR      DSPSCN
      *
      *================================================================
      *  P R O G R A M     E N D                                      *
      *                                                               *
     C                   SETON                                            LR
     C                   RETURN
      *                                                               *
      *================================================================
      /EJECT
      *****************************************************************
      *                                                               *
      *  DSPSCN - SR TO DISPLAY SCREEN                                *
      *                                                               *
      *****************************************************************
      *
     C     DSPSCN        BEGSR
      *
     C     *INKC         DOUEQ     '1'
      *
      **  Display error message subfile, display screen
      *
     C                   WRITE     SFLCTLM
     C                   EXFMT     SD0152F0
      *
      **  Clear messages from program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      SPGMQ         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
     C                   SETOFF                                       1030
      *
      **  Validate field entries
      *
     C                   IF        *INKC <> '1'
     C                   MOVEL     SNOSC         NoCcy
     C                   MOVEL     SNOSN         NoNum
     C     KNostro       CHAIN     SDNOSTL1
     C                   IF        %FOUND(SDNOSTL1)
      *
     C                   MOVEL     A7ACSN        ##ACSN
     C                   MOVEL     *BLANKS       SNOSC
     C                   MOVEL     *BLANKS       SNOSN
     C                   MOVEL     '1'           *INKC
      *
     C                   ELSE
     C                   SETON                                        1030
     C                   MOVE      'USR0073'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSR
      *
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASNMS - SR TO SEND MESSAGE TO PROGRAM MESSAGE QUEUE         *
      *                                                               *
      *****************************************************************
      *
     C     ZASNMS        BEGSR
      *
      ** Declare message file name
      *
     C                   MOVEL     'GBSDUSRMSG'  ZAMSGF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM      SPGMQ         ZAPGM            10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  MSGSUB - SR SETUP MESSAGE SUBFILE                            *
      *                                                               *
      *****************************************************************
      *
     C     MSGSUB        BEGSR
      *
      **  Clear all fields to send messages to message queue
      *
     C                   MOVEL     *BLANK        ZAPGM
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *
     C                   MOVE      *BLANKS       SPGMQ
     C                   MOVEL     'SD000152R'   SPGMQ
      *
     C                   MOVEL     '1'           *INKC
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2017
