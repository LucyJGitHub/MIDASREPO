     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Private Banking migration - SECTYDXT')        *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00031 - Migrate SECTYDXT                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 26Jan10               *
      *                 CSM001 *CREATE     Date 14Oct02               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CPBMIG14.                          *
      *  CSM001  - Upgrade of Private Banking layer.                  *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file
      *       30      Chain SECTYD - record not found
      *       31      Chain SDPLIN - record not found
      *       32      Chain INVTP  - record not found
      *       69      Read, write or chain fail
      *
     FSMPBSDPD  IF   E             DISK    INFSR(*PSSR)
     FSDPLINL0  UF A E           K DISK    INFSR(*PSSR)
     FSECTY     UF   E           K DISK    INFSR(*PSSR)
     FINVTP     IF   E           K DISK    INFSR(*PSSR)
     FSDPLINPA  UF A E             DISK    INFSR(*PSSR)
      *
      /EJECT
      *
     D PSDS           SDS
      *
      * Program Status Data Structure.
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Access to bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Set up variables, etc.
     C                   Z-ADD     0             Number_of_recs    5 0
     C                   MOVE      *BLANK        PDDLUP_a          2
     C                   MOVE      *BLANK        PDYLUP_a          2
      *
     C     INVTPD_Key    KLIST
     C                   KFLD                    NMCY
     C                   KFLD                    SITP
      *
      *  Call Access Object for bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     1             SETLL     SMPBSDPD
     C                   READ      SMPBSDPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN20         DOWEQ     '0'
      *
      * Update SECTYD, if record found.
     C     TTSESN        CHAIN     SECTYDF                            3069
     C     *IN30         IFEQ      *OFF
     C     PPAG          IFEQ      *blanks
     C     TTPAYA        ANDNE     0
     C                   MOVEL     TTPAYA        PPAG
     C                   MOVEL     'Y'           UPDATE            1
     C                   ENDIF
     C     WEIC          IFEQ      0
     C     TTWEIG        ANDNE     0
     C                   Z-ADD     TTWEIG        WEIC
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
     C     GUAR          IFEQ      *blanks
     C     TTGUAR        ANDNE     0
     C                   MOVEL     TTGUAR        GUAR
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
      *
      * Check if Instrument Type needs updating ...
     C     PBIT          IFEQ      *BLANK
     C     TTINST        IFNE      *BLANK
     C                   MOVEL     TTINST        PBIT
     C                   ELSE
     C                   MOVEL     SITP          PBIT
     C                   ENDIF
     C                   MOVEL     'Y'           UPDATE
      *
     C     PBIT          CHAIN     SDPLINL0                           3169
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      * If record not found on SDPLIN then write record ...
     C     *IN31         IFEQ      *ON
     C                   MOVEL     'D'           PDRECI
     C                   MOVEL     PBIT          PDINNR
     C                   Z-ADD     BJRDNB        PDLCD
     C                   MOVEL     'I'           PDCHTP
     C                   TIME                    PDTLUP
     C     2             SUBST     BJMRDT        PDDLUP_a
     C                   MOVEL     PDDLUP_a      PDDLUP
     C     3             SUBST     BJMRDT:3      PDMLUP
     C     2             SUBST     BJMRDT:6      PDYLUP_a
     C                   MOVEL     PDYLUP_a      PDYLUP
      *
      * Obtain further data from INVTPD.
     C     INVTPD_Key    CHAIN     INVTPDF                            3269
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C     *IN32         IFEQ      *OFF
     C                   MOVEL     INAM          PDISTN
     C                   ELSE
     C                   SETOFF                                       32
     C                   ENDIF
      *
     C                   WRITE     SDPLINP0                             69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ADD       1             Number_of_recs
      *
     C                   SETOFF                                       31
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Only update file if any fields have been updated.
     C     UPDATE        IFEQ      'Y'
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVEL     'A'           CHTP
     C                   UPDATE    SECTYDF                              69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVEL     ' '           UPDATE
     C                   ENDIF
      *
     C                   ELSE
     C                   SETOFF                                       30
     C                   ENDIF
      *
     C     READ_NEXT     TAG
      *
     C                   READ      SMPBSDPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Update SDPLIN trailer
     C     1             CHAIN     SDPLINPA                           3369
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C     *IN33         IFEQ      *OFF
     C                   ADD       Number_of_recsPDNORE
     C                   UPDATE    SDPLINZ0                             69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'Z'           PDRECI
     C                   Z-ADD     Number_of_recsPDNORE
     C                   WRITE     SDPLINZ0                             69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
