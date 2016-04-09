     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*X*I****OVRDBF*FILE(CPYDTA)*TOFILE(UPOBJDTPD)*************************                     BUG27793
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Check for objects moved between releases')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000042 - Check if file has been moved between releases     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. BUG27793           Date 07Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK025  *CREATE    Date 04Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG27793 - Make migration multi-streamed.                    *
      *  CPK025 - MidasPlus 1.3 packaging.  Changes to migration.     *
      *                                                               *
      *****************************************************************
      *
      * File containing list of objects to be migrated.
     F*CPYDTA***UF   E             DISK                                                     BUG27793
     FSMCPYDPD  UF   E           K DISK                                                     BUG27793
      * File containing list of objects moved between the DM and DTA
      *  at Release 4.
     FSMMTOTPD  IF   E             DISK
      *
     D Delete          S              1
     D Recursive       S              1
      *
      * Read first record;
     C*****1****         SETLL     CPYDTA                                                   BUG27793
     C**********         READ      CPYDTA                                                   BUG27793
     C     *LOVAL        SETLL     SMCPYDPD                                                 BUG27793
     C                   READ      SMCPYDPD                                                 BUG27793
      *
     C                   DOU       %EOF
      *
     C                   EXSR      CheckSMMTOTPD
      *
     C*****1****         SETLL     CPYDTA                                                   BUG27793
     C**********         READ      CPYDTA                                                   BUG27793
      *
     C                   ENDDO
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  CheckSMMTOTPD - Check if object name/type combination        *
      *                  exists on SMMTOTPD.  If it is then delete    *
      *                  it from CPYDTA.                              *
      *                                                               *
      *****************************************************************
      *
     C     CheckSMMTOTPD BEGSR
      *
     C     1             SETLL     SMMTOTPD
     C                   READ      SMMTOTPD
      *
     C                   DOU       %EOF or
     C                             Delete = 'Y'
      *
     C                   IF        ODOBNM = MLNAME and
     C                             ODOBTP = MLTYPE
     C**********         DELETE    CPYDTA                                                   BUG27793
     C                   DELETE    SMCPYDPD                                                 BUG27793
     C                   EVAL      Delete  = 'Y'
     C                   ENDIF
      *
     C                   READ      SMMTOTPD
      *
     C                   ENDDO
      *
     C                   EVAL      Delete = ' '
      *
     C     CheckSMMTOTPDEENDSR
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = 'N'
     C                   EVAL      Recursive = 'Y'
     C                   SETON                                        U7U8
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
