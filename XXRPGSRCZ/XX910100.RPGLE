     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2024')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Encryption Program')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  XX910100 - Midas SD Encryption Program                       *
      *                                                               *
      *  Function:  This module will encrypt and decrypt passwords    *
      *                                                               *
      *  (c) Finastra International Limited 2024                      *
      *                                                               *
      *  Last Amend No. JMI117  *CREATE    Date 19Jan24               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI117 - Encrypt and Decrypt of password                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRENCRYPT - Encrypt Password                                  *
      * SRDECRYPT - Decrypt Password                                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D ALPNM           S              1    CTDATA DIM(94) PERRCD(94)            Alphanumeric
     D ECDT            S              1    CTDATA DIM(94) PERRCD(94)            encrypt code
     D BPWD            S              1    DIM(31)                              before passwd
     D EPWD            S              1    DIM(31)                              after passwd
     D ENCP@SS         S              1    DIM(30)                              after encrypt
     D DPWD            S              1    DIM(31)                              after passwd
     D DECP@SS         S              1    DIM(30)                              after decrypt
     D AFTP@SS         S              1    DIM(30)                              encrypt passwd
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PReturnCode     S              7A
     D PSize           S              2S 0
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     C                   EVAL      PReturnCode = *Blanks
     C                   EVAL      *In01 = *Off
      *
     C                   EXSR      SrInit
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrInit- Initialise fields                                     *
      *                                                               *
      *****************************************************************
      *
     C     SrInit        BEGSR
      *
     C                   CLEAR                   BPWD
     C                   CLEAR                   ENCP@SS
     C                   CLEAR                   DECP@SS
     C                   MOVEA     BEFP@SS       BPWD
     C                   ADD       1             X
     C                   EVAL      PSIZE = %LEN(%TRIM(BEFP@SS))
      *
     C     MODE          IFEQ      'E'
     C                   EXSR      SREncrypt
     C                   ELSE
     C     MODE          IFEQ      'D'
     C                   EXSR      SRDecrypt
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRENCRYPT - Encrypt password                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRENCRYPT     BEGSR
      *
     C                   SETOFF                                       95
      *
     C                   Z-ADD     1             P                 2 0
     C     BPWD(X)       LOOKUP    ALPNM(P)                               95
     C                   Z-ADD     1             N                 2 0
      *
     C     N             DOUGT     PSIZE
      *
     C                   Z-ADD     1             S                 2 0
     C     BPWD(N)       LOOKUP    ALPNM(S)                               95
      *
      ** Check if there are any invalid characters in the data

     C     *IN95         IFEQ      '0'
     C                   EVAL      PReturnCode = '*INVCHA'
     C                   DUMP
     C                   RETURN
     C                   ENDIF
      *
     C     P             ADD       N             P
     C     P             ADD       S             P
      *
     C     P             IFGT      100
     C     P             SUB       100           P
     C                   END
      *
     C                   MOVEA     ECDT(P)       EPWD(N)
     C                   Z-ADD     S             P
     C     N             ADD       1             N
      *
     C                   END
      *
     C                   EVAL      ENCP@SS = %SUBARR(EPWD:1:PSIZE)
     C                   EVAL      AFTP@SS  =    ENCP@SS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDECRYPT - Decrypt password                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRDECRYPT     BEGSR
      *
     C                   SETOFF                                       95
      *
     C                   Z-ADD     1             P                 2 0
     C     BPWD(X)       LOOKUP    ECDT(P)                                95
     C                   Z-ADD     1             N                 2 0
      *
     C     N             DOUGT     PSIZE
      *
     C                   Z-ADD     1             S                 2 0
     C     BPWD(N)       LOOKUP    ECDT(S)                                95
     C     S             SUB       N             S
     C     S             SUB       P             S
      *
     C     S             IFLT      0
     C     S             ADD       100           S
     C                   ELSE
     C     S             IFGT      94
     C     S             SUB       94            S
     C                   END
     C                   END
      *
     C                   MOVEA     ALPNM(S)      DPWD(N)
     C                   Z-ADD     S             P
     C     N             ADD       1             N
      *
     C                   END
      *
     C                   EVAL      DECP@SS = %SUBARR(DPWD:1:PSIZE)
     C                   EVAL      AFTP@SS  =    DECP@SS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PReturnCode
     C                   PARM                    Mode              1
     C                   PARM                    BEFP@SS          30
     C                   PARM                    X                 2 0
     C                   PARM                    AFTP@SS
      *
      *
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
      *
     C     *PSSR         BEGSR

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      *
      ** Tables for passcode encryption or decryption
**  ALPNM - alphanumeric table
ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789~`!@#$%^&*()_-+={[}]|\:;"'<,>.?/
**  ECDT - encryption code table
W@9aBId[cQ(x8E:UhZ2G<zH7{6w]5k$4eL"3MvY#bnO1iP?sl0tRj~SqoT+FmV/r.>,g'X;f\|J}Cy=p-_)D*&^%KNA!`u
