     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CB Check for beginning of year')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  RPGLE/CB000201 - Midas CB Check for beginning of year        *
      *                                                               *
      *  Called from: Program GL201001                                *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. CGL201 *Create     Date 22Sep23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL201 - New Reports for Daily Transfer of Foreign Exchange  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
      *                                                               *
      *  U7 - Database error                                          *
      *  U8 - Database error                                          *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Array containing Copyright statement
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      /COPY ZSRSRC,ZHOLELE
      /COPY ZSRSRC,ZHOLILE
      *
      /COPY ZSRSRC,ZHOLDSLE
      *
      **  External Data Structure for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Short Data Structure for Access Programs
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Local data area for database error details
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      *
      ** Month of run date
      *
     D                 DS
     D RUNDAT                  1      7
     D YER1                    6      7
      *
      ** Month of previous working day
      *
     D                 DS
     D ZADATE                  1      7
     D YER2                    6      7
      *
     C     *ENTRY        PLIST
     C                   PARM                    RUN               1
     C                   PARM                    RTN               1
     C                   MOVEA     CPY@          BIS@             80
     C     *DTAARA       DEFINE                  LDA
      *
      ** Use access program to obtain record from SDBANKPD
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error if blank return code not received from access pgm
      *
     C     P@RTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   SETON                                        U7U8
     C                   Z-ADD     1             DBASE
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     'CB000201'    DBPGM
     C                   OUT       LDA
     C                   RETURN
     C                   ENDIF
      *
      ** Check if previous working day was in previous month
      *
     C                   MOVE      BJMRDT        RUNDAT
     C                   MOVE      BJLCCY        ZCCY
     C                   Z-ADD     1             ZNRDYS
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZBKDT
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDYNBR            5 0
     C                   PARM      BJDFIN        ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *
      ** Set run value if conditions met
      *
     C     YER1          IFNE      YER2
     C                   MOVE      'Y'           RUN
     C                   ELSE
     C                   MOVE      'N'           RUN
     C                   ENDIF
      *
      ** Set blank return code, close files and end program
      *
     C                   MOVE      '*FREE  '     ZOPTN
     C                   EXSR      ZACCH
     C                   MOVE      ' '           RTN
     C                   SETON                                        LR
     C                   RETURN
      *
      /COPY ZSRSRC,ZACCHLE
      /COPY ZSRSRC,ZBKDT_ILE
** CPY@   OBJECT COPYRIGHT
(c) Finastra International Limited 2023
