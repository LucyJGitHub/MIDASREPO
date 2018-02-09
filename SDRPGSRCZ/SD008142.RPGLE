     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Stamp Tax Flat Amount Calculation')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data                                        *
      *                                                               *
      *  SD008142 - Stamp Tax Flat Amount Calculation                 *
      *                                                               *
      *  Function: Will calculate the flat amount for stamp tax       *
      *                                                               *
      *  (c) Copyright Finastra International Limited 2010            *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE075AP           Date 06Aug12               *
      *                 CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE075AP - COB Restructure - LE COB Optimisation Phase 1     *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
      *
      ** Array containing Copyright statement
      *
     D A@CPY           DS
      *
      ** Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, short data structure
      *
     D LDA           E DS           256    EXTNAME(LDA)
     D  W24          E                     EXTFLD(SPARE)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure - gives Job/Workstation name and
      ** User ID
      *
     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
      *
     D ValueDate       DS                  INZ
     D  V#Date                 1      8  0
     D  V#CC                   1      2  0
     D  V#YY                   3      4  0
     D  V#YEAR                 1      4  0
     D  V#MM                   5      6  0
     D  V#DD                   7      8  0
      *
     D MatDate         DS                  INZ
     D  M#Date                 1      8  0
     D  M#CC                   1      2  0
     D  M#YY                   3      4  0
     D  M#YEAR                 1      4  0
     D  M#MM                   5      6  0
     D  M#DD                   7      8  0
     D                 DS                  INZ
     D  U#DMY                  1      6  0
     D  U#DD                   1      2  0
     D  U#MM                   3      4  0
     D  U#YY                   5      6  0
     D                 DS                  INZ
     D  U#INDT                 1      6  0
     D  U#D                    1      2  0
     D  U#M                    3      4  0
     D  U#Y                    5      6  0
     D                 DS                  INZ
     D  @TYPE                  1      4
     D  @@TYPE                 1      2
     D  @@STYP                 3      4
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
      *
     D SDSTPD        E DS                  EXTNAME(SDSTPDPD)
      ** Stamp Tax details read
      *
      *****************************************************************
      *
      *                M A I N  P R O C E S S I N G
      *
      *****************************************************************
      *
      ** Initialise data
      *
     C                   EXSR      SRINIT
      *
      ** Check that there are rates
      *
     C                   IF        (A3F01Y > 0) or
     C                             (A3F05Y > 0) or
     C                             (A3F99Y > 0)
     C     U#VDAT        IFEQ      *ZEROS
     C     U#MDAT        ANDEQ     *ZEROS
      *
      ** Check dates passed are valid
      *
     C                   MOVE      U#VDTA        ZDATE
     C                   CALL      'ZDATE1'                             9090
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE
     C                   PARM      BJDFIN        ZDATFM
     C                   PARM      *ZEROS        ZDAYNO
      *
     C                   IF        Zerr = '       '
     C                   Z-ADD     ZDAYNO        U#VDAT            5 0
      *
     C                   MOVE      U#MDTA        ZDATE
     C                   CALL      'ZDATE1'                             9090
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE
     C                   PARM      BJDFIN        ZDATFM
     C                   PARM      *ZEROS        ZDAYNO
      *
     C                   IF        Zerr = '       '
     C                   Z-ADD     ZDAYNO        U#MDAT            5 0
      *
      ** Dates are valid and rates are set
      ** Calculate number of months
      *
     C                   Exsr      SrMonths
      *
      ** Determine new rate
      *
     C                   Exsr      SrNewRate
      *
     C                   Endif
     C                   Endif
     C                   ELSE
     C                   Exsr      SrMonths
     C                   Exsr      SrNewRate
     C                   Endif
      *
     C                   Endif
      *
     C                   EXSR      SREND
      *
      *****************************************************************
      * Calculate number of months
      *****************************************************************
      *
     C     SrMonths      BEGSR
      *
      ** Format as CCYYMMDD for value date
      *
     C                   CALL      'ZDATE2'                             9090
     C                   PARM      U#VDAT        ZDAYNO            5 0
     C                   PARM      'D'           ZDATFM            1
     C                   PARM      *ZEROS        ZDATE             6 0
     C                   PARM      *BLANKS       ZADATE            7
      *
     C                   Z-ADD     ZDATE         U#DMY
     C                   Z-ADD     U#DD          V#DD
     C                   Z-ADD     U#MM          V#MM
     C                   Z-ADD     U#YY          V#YY
     C                   If        ZDAYNO > 10227
     C                   Z-ADD     20            V#CC
     C                   Else
     C                   Z-ADD     19            V#CC
     C                   Endif
      *
      ** Format as CCYYMMDD for maturity date
      *
     C                   CALL      'ZDATE2'                             9090
     C                   PARM      U#MDAT        ZDAYNO            5 0
     C                   PARM      'D'           ZDATFM            1
     C                   PARM      *ZEROS        ZDATE             6 0
     C                   PARM      *BLANKS       ZADATE            7
      *
     C                   Z-ADD     ZDATE         U#DMY
     C                   Z-ADD     U#DD          M#DD
     C                   Z-ADD     U#MM          M#MM
     C                   Z-ADD     U#YY          M#YY
     C                   If        ZDAYNO > 10227
     C                   Z-ADD     20            M#CC
     C                   Else
     C                   Z-ADD     19            M#CC
     C                   Endif
      *
      ** Number of months
      *
     C                   Clear                   NbrMonths         7 0
     C                   Eval      NbrMonths = (M#YEAR - V#YEAR) * 12
     C                             + (M#MM - V#MM)
      *
     C                   Clear                   Vplus1            8 0
     C                   Clear                   Vplus5            8 0
     C                   Eval      Vplus1 = V#date + 10000
     C                   Eval      Vplus5 = V#date + 50000
      *
      ** Set Value date to maturity date month
      *
     C                   Eval      V#MM = M#MM
     C                   Eval      V#YEAR = M#YEAR
     C                   If        M#Date > V#Date
     C                   Eval      NbrMonths = NbrMonths + 1
     C                   Endif
      *
     C     ExMonths      ENDSR
      *
      *****************************************************************
      * Determine new tax rate
      *****************************************************************
      *
     C     SrNewRate     BEGSR
      *
     C                   Eval      U#MNTH = NbrMonths
      *
     C                   Select
      *
      ** If Number of months is less than 12 months
      *
     C                   When      (NbrMonths < 13) and (M#DATE < Vplus1)
     C                   Eval      U#TAXR = NbrMonths * A3F01Y
     C                   Eval      U#TXBR = A3F01Y
     C                   Eval      U#PERD = ' '
      *
      ** If Number of months is less than 5 years
      *
     C                   When      (NbrMonths < 61) and (M#DATE < Vplus5)
     C                   Eval      U#TAXR = A3F05Y
     C                   Eval      U#TXBR = A3F05Y
     C                   Eval      U#PERD = '1'
     C                   Other
     C                   Eval      U#TAXR = A3F99Y
     C                   Eval      U#TXBR = A3F99Y
     C                   Eval      U#PERD = '5'
     C                   Endsl
      *
     C     ExNewrate     ENDSR
      *
      *****************************************************************
      * Initial Processing
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Input parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    U#VDTA            6
     C                   PARM                    U#MDTA            6
     C                   PARM                    SDSTPD
     C                   PARM                    U#TAXR           13 8
     C                   PARM                    U#PERD            1
     C                   PARM                    U#TXBR           13 8
     C                   PARM                    U#MNTH            7 0
     C                   PARM                    U#VDAT
     C                   PARM                    U#MDAT
      *
      **   Define the LDA for error handling
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Call Access Program to obtain Banks details from PF/SDBANKPD
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '       '     ULRTCD            7
     C                   PARM      '*FIRST '     ULOPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error.
      *
     C     ULRTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD008142'    DBPGM
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      * EXIT FROM PROGRAM
      *****************************************************************
     C     SREND         BEGSR
      *                                                               *
     C**********         SETON                                        LR                    CLE075AP
     C                   RETURN
      *                                                               *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
** CPY@
(c) Copyright Finastra International Limited 2010
