     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  ALWNULL(*USRCTL)                                             *
/*EXI *  TEXT('Midas XX CoB Front Office Id Update')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business                                    *
      *                                                               *
      *  XX023002 - Front Office ID update during COB                 *
      *                                                               *
      *  Function:  This program updates Front Office Id reference    *
      *             from Kondor ID during Close of Business.          *
      *             (Based on in-house program CDS001R, and IRS003R,  *
      *              TRD001R and STY001R).                            *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD054783           Date 27Jul20               *
      *  Prev Amend No. LCI023  *CREATE    Date 03Jul18               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD054783 - LCI023 - Front Office Transaction ID (HKFRNT) not *
      *             being set in MMDELDPP.                            *
      *  LCI023 - Local Front Office Id. Upgrade to FBM 2.1           *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       90      Chain indicator                                 *
      *       99      Read indicator                                  *
      *                                                               *
      *****************************************************************

     FGPZONEL2  IF   E           K DISK    INFSR(*PSSR)

     FI_TGZLDNI0IF   E           K DISK    INFSR(*PSSR)
     FMMDEALL3  UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(MMDENSP0)                                 MD054783
     F                                     IGNORE(MMDENBP0)                                 MD054783
     FI_TXXSIRS0IF   E           K DISK    INFSR(*PSSR)
     FXXSIRSL0  UF   E           K DISK    INFSR(*PSSR)

     FI_TXXTRAD0IF   E           K DISK    INFSR(*PSSR)
     FTRADS     UF   E           K DISK    INFSR(*PSSR)

     FSECTYL4   UF   E           K DISK    INFSR(*PSSR)
      *****************************************************************
      *
     D SDStat        E DS                  Extname(SDStat) DTAARA(SDStat)
      ** SD data area

     d dsfdy         e ds

      ** External data structure for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

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

     D @RUN            S              1

      *****************************************************************
     C/EJECT
      *****************************************************************
      *
      *                M A I N  P R O C E S S I N G
      *
      *****************************************************************
      *
      ** Process MM deals
      *
     C     *Loval        Setll     I_TGZLDNI0
     C                   Read      I_TGZLDNI0                             99
      *
     C                   Dow       *In99 = '0'
      *
     C     Pzone         Ifeq      ZONE
     C                   MoveL     DDDlno        DealNo            6 0
     C     DealNo        Chain     MMDEALL3                           90
     C     *In90         Ifeq      *Off
     C*****HkFrnt        andne     *Blanks                                                  MD054783
     C     HkFrnt        andeq     *Blanks                                                  MD054783
     C                   Movel     Kondor        HkFrnt
     C                   Update    MMDELDP0
     C                   Endif
     C                   Endif
      *
     C                   Read      I_TGZLDNI0                             99
     C                   Enddo
      *
      ** Process SIRS deals
      *
     C     *Loval        Setll     I_TXXSIRS0
     C                   Read      I_TXXSIRS0                             99
      *
     C                   Dow       *In99 = '0'
      *
     C     Pzone         Ifeq      CUSTZONE
     C                   MoveL     SDlno         DealNo            6 0
     C     DealNo        Chain     XXSIRSL0                           90
     C     *In90         Ifeq      *Off
     C     Frnt          andeq     *Blanks
     C                   Movel     Kondor        Frnt
     C                   Update    DEALSDGF
     C                   Endif
     C                   Endif
      *
     C                   Read      I_TXXSIRS0                             99
     C                   Enddo
      *
      ** Process SE Trades
      *
     C     *Loval        Setll     I_TXXTRAD0
     C                   Read      I_TXXTRAD0                             99
      *
     C                   Dow       *In99 = '0'
      *
     C     Pzone         Ifeq      ZONE
     C     DDTdrf        Chain     TRADS                              90
     C     *In90         Ifeq      *Off
     C     Frnt          andeq     *Blanks
     C                   Movel     Kondor        Frnt
     C                   Update    TRADSDF
     C                   Endif
     C                   Endif
      *
     C                   Read      I_TXXTRAD0                             99
     C                   Enddo
      *
      ** Process SE Securities
      *
     C     *Loval        Setll     SECTYL4
     C                   Read      SECTYL4                                99
      *
     C                   Dow       *In99 = '0'
      *
     C     Frnt          Ifeq      *Blanks
     C                   Movel     Dasr          Frnt
     C                   Update    SECTYDF
     C                   Endif
      *
     C                   Read      SECTYL4                                99
     C                   Enddo
      *
      **   Exit from program
      *
     C                   Exsr      END
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT FROM PROGRAM
      *****************************************************************
     C     END           Begsr
      *
     C                   Eval      *INLR = *ON
     C                   Return
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * Initial processing
      *****************************************************************
      *
     C     *Inzsr        Begsr
      *
      **   Define the LDA for error handling
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Get Zone Name from system ID.
     C                   In        SDSTAT
     C     Libr          Chain     GPZONED0                           90

     C                   Move      ZOZONE        PZone            10

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
