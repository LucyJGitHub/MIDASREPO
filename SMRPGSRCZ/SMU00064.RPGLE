     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Build SEDEVD for reden. securities')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00064 - Crate missing intitial value records to SEDEVD    *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993 *CREATE    Date 26Jan10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program SXXXX0101.                         *
      *                                                               *
      *  Function: Create missing initial value records in diary      *
      *            events for redenominated which were setup with an  *
      *            incorrect original entry date                      *
      *                                                               *
      *                                                               *
      *****************************************************************
      ** FILE DEFINITIONS
      ** ----------------
      *
     FSECTY     IP   E             DISK
     FINVTP     IF   E           K DISK
     FSECET     UF A E           K DISK
     FSEDEVA    UF   E             DISK
      *
     D NAR             S             35    DIM(1) CTDATA PERRCD(1)
      *
     ISECTYDF
     I              RECI                        RECIX
      *
     C* Key to access SECET
     C     KEY1          KLIST
     C                   KFLD                    SESN
     C                   KFLD                    WWET              2
     C                   KFLD                    WWED              5 0
      *
      * Key to access INVTP
     C     KINVTP        KLIST
     C                   KFLD                    NMCY
     C                   KFLD                    SITP
      *
     C     *IN50         IFEQ      '0'
     C                   Z-ADD     0             DTOTA             5 0
     C                   SETON                                        50
     C                   END
      *
     C     RECIX         IFEQ      'D'
      *
      *  PAYMENT CURRENCY (SPYC) NE BLANK - OUTPUT TYPE 'XR'
     C     SPYC          IFNE      *BLANKS
     C                   MOVE      'XR'          WWET
     C                   MOVE      *ZEROS        WWED
     C     KEY1          CHAIN     SEDEVDF                            33
     C     *IN33         IFEQ      '1'
     C                   MOVE      'M'           RECI
     C                   MOVE      SESN          SDSN
     C                   Z-ADD     *ZERO         SDED
     C                   MOVE      NAR(1)        SDNV
     C                   Z-ADD     *ZERO         SDVA
     C                   Z-ADD     *ZERO         SDPD
     C                   MOVE      *BLANKS       SDCV
     C                   Z-ADD     *ZERO         SDAD
     C                   Z-ADD     *ZERO         SDDT
     C                   Z-ADD     *ZERO         LCD
     C                   MOVE      *BLANK        CHTP
     C                   Z-ADD     *ZERO         TNLU
     C                   MOVE      'XR'          SDET
     C                   Z-ADD     *ZERO         SDCP
     C                   Z-ADD     *ZERO         SRPT
     C                   Z-ADD     *ZERO         SDTR
     C                   MOVE      *BLANK        SRMI
     C                   Z-ADD     *ZERO         SDPD
     C                   Z-ADD     *ZERO         SDNC
     C                   Z-ADD     *ZERO         SDPP
     C                   Z-ADD     *ZERO         SDPC
     C                   Z-ADD     *ZERO         SDTA
     C                   Z-ADD     *ZERO         SDTP
     C                   Z-ADD     *ZERO         SDRP
     C                   MOVE      SPYC          SDCX
     C                   Z-ADD     SEXR          SDCE
     C                   MOVE      SMDI          SDMD
      *
      *  WRITE THE RECORD TO LF/SECET
     C                   WRITE     SEDEVDF
     C                   ADD       1             DTOTA
     C                   END
     C                   END
      *
      *  COUPON RATE NE ZERO - OUTPUT TYPE 'IR'
     C     CPNR          IFNE      *ZERO
     C                   MOVE      'IR'          WWET
     C     KEY1          CHAIN     SEDEVDF                            33
     C     *IN33         IFEQ      '1'
     C                   MOVE      'M'           RECI
     C                   MOVE      SESN          SDSN
     C                   Z-ADD     *ZERO         SDED
     C                   MOVE      NAR(1)        SDNV
     C                   Z-ADD     *ZERO         SDVA
     C                   Z-ADD     *ZERO         SDPD
     C                   MOVE      *BLANKS       SDCV
     C                   Z-ADD     *ZERO         SDAD
     C                   Z-ADD     *ZERO         SDDT
     C                   Z-ADD     *ZERO         LCD
     C                   MOVE      *BLANK        CHTP
     C                   Z-ADD     *ZERO         TNLU
     C                   MOVE      'IR'          SDET
     C                   Z-ADD     *ZERO         SDCP
     C                   Z-ADD     *ZERO         SRPT
     C                   Z-ADD     *ZERO         SDTR
     C                   MOVE      *BLANK        SRMI
     C                   Z-ADD     *ZERO         SDPD
     C                   Z-ADD     CPNR          SDNC
     C                   Z-ADD     *ZERO         SDPP
     C                   Z-ADD     *ZERO         SDPC
     C                   Z-ADD     *ZERO         SDTA
     C                   Z-ADD     *ZERO         SDTP
     C                   Z-ADD     *ZERO         SDRP
     C                   MOVE      *BLANK        SDCX
     C                   Z-ADD     *ZERO         SDCE
     C                   MOVE      *BLANK        SDMD
      *
      *  WRITE THE RECORD TO LF/SECET
     C                   WRITE     SEDEVDF
     C                   ADD       1             DTOTA
     C                   END
     C                   END
      *
      *  PP CALL INDICATOR EQ 'Y' - OUTPUT TYPE 'PP'
     C     PPDI          IFEQ      'Y'
     C                   MOVE      'PP'          WWET
     C     KEY1          CHAIN     SEDEVDF                            33
     C     *IN33         IFEQ      '1'
     C                   MOVE      'M'           RECI
     C                   MOVE      SESN          SDSN
     C                   Z-ADD     *ZERO         SDED
     C                   MOVE      NAR(1)        SDNV
     C                   Z-ADD     *ZERO         SDVA
     C                   Z-ADD     *ZERO         SDPD
     C                   MOVE      *BLANKS       SDCV
     C                   Z-ADD     *ZERO         SDAD
     C                   Z-ADD     *ZERO         SDDT
     C                   Z-ADD     *ZERO         LCD
     C                   MOVE      *BLANK        CHTP
     C                   Z-ADD     *ZERO         TNLU
     C                   MOVE      'PP'          SDET
     C                   Z-ADD     *ZERO         SDCP
     C                   Z-ADD     *ZERO         SRPT
     C                   Z-ADD     *ZERO         SDTR
     C                   MOVE      *BLANK        SRMI
     C                   Z-ADD     *ZERO         SDPD
     C                   Z-ADD     CPNR          SDNC
      *
     C     KINVTP        CHAIN     INVTP                              36
     C     PROT          IFEQ      '4'
     C                   Z-ADD     CPDP          SDPP
     C                   Z-ADD     CPDP          SDTA
     C                   Z-ADD     *ZERO         SDPC
     C                   Z-ADD     *ZERO         SDTP
     C                   ELSE
     C                   Z-ADD     *ZERO         SDPP
     C                   Z-ADD     *ZERO         SDPC
     C                   MOVE      CPDP          SDPC
     C                   END
      *
     C                   Z-ADD     SDPP          SDTA
     C                   Z-ADD     SDPC          SDTP
     C                   Z-ADD     *ZERO         SDRP
     C                   MOVE      *BLANK        SDCX
     C                   Z-ADD     *ZERO         SDCE
     C                   MOVE      *BLANK        SDMD
      *
      *  WRITE THE RECORD TO LF/SECET
     C                   WRITE     SEDEVDF
     C                   ADD       1             DTOTA
     C                   END
     C                   END
      *
      *  CURRENT FACTOR NE ZERO - OUTPUT TYPE 'MP'
     C     CFCT          IFNE      *ZERO
     C                   MOVE      'MP'          WWET
     C     KEY1          CHAIN     SEDEVDF                            33
     C     *IN33         IFEQ      '1'
     C                   MOVE      'M'           RECI
     C                   MOVE      SESN          SDSN
     C                   Z-ADD     *ZERO         SDED
     C                   MOVE      NAR(1)        SDNV
     C                   Z-ADD     *ZERO         SDVA
     C                   Z-ADD     *ZERO         SDPD
     C                   MOVE      *BLANKS       SDCV
     C                   Z-ADD     *ZERO         SDAD
     C                   Z-ADD     *ZERO         SDDT
     C                   Z-ADD     *ZERO         LCD
     C                   MOVE      *BLANK        CHTP
     C                   Z-ADD     *ZERO         TNLU
     C                   MOVE      'MP'          SDET
     C                   Z-ADD     CFCT          SDCP
     C                   Z-ADD     *ZERO         SRPT
     C                   Z-ADD     *ZERO         SDTR
     C                   MOVE      *BLANK        SRMI
     C                   Z-ADD     *ZERO         SDPD
     C                   Z-ADD     CPNR          SDNC
     C                   Z-ADD     *ZERO         SDPP
     C                   Z-ADD     *ZERO         SDPC
     C                   Z-ADD     *ZERO         SDTA
     C                   Z-ADD     *ZERO         SDTP
     C                   Z-ADD     *ZERO         SDRP
     C                   MOVE      *BLANK        SDCX
     C                   Z-ADD     *ZERO         SDCE
     C                   MOVE      *BLANK        SDMD
      *
      *  WRITE THE RECORD TO LF/SECET
     C                   WRITE     SEDEVDF
     C                   ADD       1             DTOTA
     C                   END
     C                   END
     C*
     C                   END
     C*
     CLR   1             CHAIN     SEDEVAF                            99
     CLRN99              ADD       DTOTA         NLRB
     CLRN99              ADD       DTOTA         NORE
     CLRN99              UPDATE    SEDEVAF
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
** NAR
INITIAL VALUE
