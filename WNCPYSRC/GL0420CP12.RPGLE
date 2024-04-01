      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL0420)                                *
      *                                                               *
      *  GL0420CP12 - Balance Statements (A/C Formats)                *
      *                                                               *
      *  Last Amend No. UUC102 *CREATE  Date 16Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  UUC102 - Upgrade of CAR UUC063 to BF Midas 2.1               *
      *           UUC063 - Balance Statement Enhancement              *
      *                                                               *
      *****************************************************************
     C                   CALL      'EU0200'
     C                   PARM      *BLANK        P@RTCD            7
     C                   PARM      PSTBAL        P@FRAM           18 3
     C                   PARM      CCY           P@FRCY            3
     C                   PARM      BKEURO        P@TOCY            3
     C     EUPBAL        PARM                    P@OUTA           15 0
     C                   PARM                    P@INTA           18 3
     C                   PARM                    P@EXRT           15 9
     C                   PARM                    P@MDIN            1
      *
