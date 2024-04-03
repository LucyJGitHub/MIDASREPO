      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL0420)                                *
      *                                                               *
      *  GL0420CP29 - Midas GL Balance Statements                     *
      *                                                               *
      *  Last Amend No. UUC102 *CREATE  Date 16Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  UUC102 - Upgrade of CAR UUC063 to BF Midas 2.1               *
      *           UUC063 - Balance Statement Enhancement              *
      *                                                               *
      *****************************************************************
      *    WRITE A NARRATIVE
      *
      *****************************************************************
     C     ACTION        BEGSR                                                  UUC102
      *                                                                         UUC102
     C                   MOVE      *BLANKS       DEXTEN           35            UUC102
      *                                                                         UUC102
     C                   MOVEL     ZAEXRF        DEXTEN                         UUC102
     C                   EXCEPT    EXTEN                                        UUC102
     C                   ADD       1             LINCNT                         UUC102
     C     LINCNT        COMP      33                                 45  45    UUC102
      *                                                                         UUC102
      **   IF END OF PAGE INCREMENT LSTP AND ZEROISE LINE COUNTER               UUC102
     C   45STPA          ADD       1             STPAX             3 0          UUC102
     C   45STPG          ADD       1             STPG                           UUC102
     C   45              Z-ADD     0             LINCNT                         UUC102
     C   45              EXCEPT    ENDPG                                        UUC102
     C   45              Z-ADD     PSTBAL        PSTBF                83        UUC102
     C   45              MOVEL     'CONTD. '     LSTDA                          UUC102
      *                                                                         UUC102
     C                   CALL      'EU0200'                                     UUC102
     C                   PARM      *BLANK        P@RTCD            7            UUC102
     C                   PARM      PSTBAL        P@FRAM           18 3          UUC102
     C                   PARM      CCY           P@FRCY            3            UUC102
     C                   PARM      BKEURO        P@TOCY            3            UUC102
     C     EUPBAL        PARM                    P@OUTA           15 0          UUC102
     C                   PARM                    P@INTA           18 3          UUC102
     C                   PARM                    P@EXRT           15 9          UUC102
     C                   PARM                    P@MDIN            1            UUC102
      *                                                                         UUC102
      * If end of page, move C/F Euro bal. to B/F Euro bal. of next page        UUC102
     C     *IN45         IFEQ      *ON                                          UUC102
     C                   Z-ADD     EUPBAL        EUPBF                          UUC102
     C                   ENDIF                                                  UUC102
      *                                                                         UUC102
      **   DETERMINE IF NEW PAGE NEEDED FOR STATEMENT                           UUC102
     C   45STPAX         COMP      LSTPX                                  48    UUC102
     C   45LINCNT        ADD       1             LINCNT                         UUC102
     C  N48                                                                     UUC102
     COR 45LINCNT        COMP      1                                      50    UUC102
      *                                                                         UUC102
      **   SET INDICATORS FOR PRINT                                             UUC102
     C   45              EXSR      SETONS                                       UUC102
 B2  C     *IN50         IFEQ      '1'                                          UUC102
     C                   EXCEPT                                                 UUC102
 E2  C                   END                                                    UUC102
     C   45              SETOFF                                       506061    UUC102
     C   45              SETOFF                                       626364    UUC102
     C   45              SETOFF                                       656667    UUC102
     C   45              SETOFF                                       808187    UUC102
     C   45              SETOFF                                       89        UUC102
      *                                                                         UUC102
     C                   ENDSR                                                  UUC102
