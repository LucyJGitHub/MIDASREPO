/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MR Generate Transaction Events')
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MRGENTEVT - Generate Transaction Events                      *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CMR001             Date 01Sep04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CMR001 - MidasPlus Reporting                                 *
      *                                                               *
      *****************************************************************
 
     FMRTRAPPD  IP   E             DISK    INFSR(*PSSR)
     FMRTREVPD  O    E             DISK    INFSR(*PSSR)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      * FX Deal Principal at Maturity Events
 
     C     I#MOD         IFEQ      'DL'
     C     EXSUB         ANDEQ     'FXDL'
     C     EXMDAT        ANDGT     EXVCD
     C     EXPAMT        ANDNE     0
     C                   EXSR      FXPM_EVENT
     C                   ENDIF
 
      * Loans/Deposits Interest at Maturity Events
 
     C     I#MOD         IFEQ      'DL'
     C     EXSUB         ANDEQ     'LDNI'
     C     EXNIDT        ANDGT     EXVCD
     C     EXNIDT        ANDEQ     EXMDAT
     C     EXNIMT        ANDNE     0
     C                   EXSR      LDIM_EVENT
     C                   ENDIF
 
      * Loans/Deposits Principal at Maturity Events
 
     C     I#MOD         IFEQ      'DL'
     C     EXSUB         ANDEQ     'LDNI'
     C     EXMDAT        ANDGT     EXVCD
     C     EXPAMT        ANDNE     0
     C                   EXSR      LDPM_EVENT
     C                   ENDIF
 
      * NAs Purchased Interest at Maturity Events
 
     C     I#MOD         IFEQ      'DL'
     C     EXSUB         ANDEQ     'NASP'
     C     EXNIDT        ANDGT     EXVCD
     C     EXNIDT        ANDEQ     EXMDAT
     C     EXNIMT        ANDNE     0
     C                   EXSR      NAIM_EVENT
     C                   ENDIF
 
      * NAs Purchased Principal at Maturity Events
 
     C     I#MOD         IFEQ      'DL'
     C     EXSUB         ANDEQ     'NASP'
     C     EXMDAT        ANDGT     EXVCD
     C     EXPAMT        ANDNE     0
     C                   EXSR      NAPM_EVENT
     C                   ENDIF
 
      * Loan Interest at Maturity Events
 
     C     I#MOD         IFEQ      'LE'
     C     EXSUB         ANDEQ     'LOAN'
     C     EXNIDT        ANDGT     EXVCD
     C     EXNIDT        ANDEQ     EXMDAT
     C     EXNIMT        ANDNE     0
     C                   EXSR      LOIM_EVENT
     C                   ENDIF
 
      * Loan Principal at Maturity Events
 
     C     I#MOD         IFEQ      'LE'
     C     EXSUB         ANDEQ     'LOAN'
     C     EXMDAT        ANDGT     EXVCD
     C     EXPAMT        ANDNE     0
     C                   EXSR      LOPM_EVENT
     C                   ENDIF
 
      /SPACE 5
     C**********************************************************************************
     C     FXPM_EVENT    BEGSR
      * mat/prin
     C                   MOVEL     'Y'           EXREVT
     C                   MOVEL     'M'           EXEVDC
     C                   MOVEL     'P'           EXEVAT
     C                   Z-ADD     EXPAMT        EXEVAM
     C                   MOVEL     EXCYCD        EXEVCY
     C                   Z-ADD     EXMDAT        EXEVDT
     C                   WRITE     MRTREVD0
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     LDIM_EVENT    BEGSR
      * mat/intn
     C                   MOVEL     'Y'           EXREVT
     C                   MOVEL     'M'           EXEVDC
     C                   MOVEL     'I'           EXEVAT
     C                   Z-ADD     EXNIMT        EXEVAM
     C                   MOVEL     EXCYCD        EXEVCY
     C                   Z-ADD     EXNIDT        EXEVDT
     C                   WRITE     MRTREVD0
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     LDPM_EVENT    BEGSR
      * mat/prin
     C                   MOVEL     'Y'           EXREVT
     C                   MOVEL     'M'           EXEVDC
     C                   MOVEL     'P'           EXEVAT
     C                   Z-ADD     EXPAMT        EXEVAM
     C                   MOVEL     EXCYCD        EXEVCY
     C                   Z-ADD     EXMDAT        EXEVDT
     C                   WRITE     MRTREVD0
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     NAIM_EVENT    BEGSR
      * mat/intn
     C                   MOVEL     'Y'           EXREVT
     C                   MOVEL     'M'           EXEVDC
     C                   MOVEL     'I'           EXEVAT
     C                   Z-ADD     EXNIMT        EXEVAM
     C                   MOVEL     EXCYCD        EXEVCY
     C                   Z-ADD     EXNIDT        EXEVDT
     C                   WRITE     MRTREVD0
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     NAPM_EVENT    BEGSR
      * mat/prin
     C                   MOVEL     'Y'           EXREVT
     C                   MOVEL     'M'           EXEVDC
     C                   MOVEL     'P'           EXEVAT
     C                   Z-ADD     EXPAMT        EXEVAM
     C                   MOVEL     EXCYCD        EXEVCY
     C                   Z-ADD     EXMDAT        EXEVDT
     C                   WRITE     MRTREVD0
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     LOIM_EVENT    BEGSR
      * mat/intn
     C                   MOVEL     'Y'           EXREVT
     C                   MOVEL     'M'           EXEVDC
     C                   MOVEL     'I'           EXEVAT
     C                   Z-ADD     EXNIMT        EXEVAM
     C                   MOVEL     EXCYCD        EXEVCY
     C                   Z-ADD     EXNIDT        EXEVDT
     C                   WRITE     MRTREVD0
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     LOPM_EVENT    BEGSR
      * mat/prin
     C                   MOVEL     'Y'           EXREVT
     C                   MOVEL     'M'           EXEVDC
     C                   MOVEL     'P'           EXEVAT
     C                   Z-ADD     EXPAMT        EXEVAM
     C                   MOVEL     EXCYCD        EXEVCY
     C                   Z-ADD     EXMDAT        EXEVDT
     C                   WRITE     MRTREVD0
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     *PSSR         BEGSR
 
     C     W#RUN         IFEQ      *BLANKS
 
     C                   MOVE      'Y'           W#RUN             1
 
     C                   MOVEL     '*ERROR'      I#RTCD            7
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
 
     C                   DUMP
      *
      * If no identified cause of error
      *
     C     I#ERMS        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF
      *
      * Log an error on the error log
      *
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = I#ERMS
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000
 
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    I#MOD             2
 
      * Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   MOVE      *BLANK        I#ERMS           50
 
     C                   ENDSR
     C**********************************************************************************
