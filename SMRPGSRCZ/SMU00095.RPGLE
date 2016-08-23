     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Find last day of previous month')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00095 - Find last day of previous month                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BG26993            Date 26Jan10               *
      *  Prev Amend No. 172614 *CREATE     Date 26Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program S17261402.                         *
      *  172614  - CoB component lasting many hours                   *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      /COPY ZSRSRC,ZHOLELE
      /COPY ZSRSRC,ZHOLILE
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      * External data structure for access program prompt
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * First data structure for access program short data structure
      *
      *    Month of run date
     D  RUNDAT                 1      7
     D  MON1                   3      5
     D                 DS
      *
      *    Month of previous working day
     D  ZADATE                 1      7
     D  MON2                   3      5
      *
     C     *ENTRY        PLIST
     C                   PARM                    LSTDAY            5 0
      *
      *    Use access program to obtain record from SDBANKPD
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error if blank return code not received from access pgm
     C     P@RTCD        IFNE      *BLANK
     C                   SETON                                          U7U8
     C                   RETURN
     C                   ENDIF
      *
      * Store today's runday date in ddmmmyy format
     C                   MOVE      BJMRDT        RUNDAT
      *
      * Check if previous day has a different month
     C                   MOVE      BJLCCY        ZCCY
     C                   Z-ADD     1             ZNRDYS
      *
      * Go around loop until last day of previous month found
     C     *IN20         DOUEQ     *ON
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZBKDT
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDYNBR            5 0
     C                   PARM      BJDFIN        ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *
      * If last day of previous month found then end loop
     C     MON1          IFNE      MON2
     C                   SETON                                        20
     C                   Z-ADD     BJRDNB        LSTDAY
     C                   ELSE
     C     BJRDNB        SUB       1             BJRDNB
     C                   ENDIF
      *
     C                   ENDDO
      *
      *    Set blank return code, close files and end program
      *
     C                   MOVE      '*FREE  '     ZOPTN
     C                   EXSR      ZACCH
     C                   SETON                                        LR
     C                   RETURN
      /COPY ZSRSRC,ZACCHLE
      /COPY ZSRSRC,ZBKDT_ILE
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      * Check to see that *PSSR has not already been called.
     C     *INLR         IFNE      *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
