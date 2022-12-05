      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL0420)                                *
      *                                                               *
      *  GL0420CP15 - Balance Statements (A/C Formats)                *
      *                                                               *
      *  Last Amend No. MD058751        Date 03Sep21                  *
      *  Prev Amend No. UUC102 *CREATE  Date 16Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058751 - Missing tag :86: on MT940s as not extracted by    *
      *             CAR UUC103. Alphanumeric batch numbers not        *
      *             checked correctly.                                *
      *  UUC102 - Upgrade of CAR UUC063 to BF Midas 2.1               *
      *           UUC063 - Balance Statement Enhancement              *
      *                                                               *
      *****************************************************************
      *                                                                         UUC102
     C     @DTA          IFEQ      'Ñ'                                          UUC102
     C     UUC102        ANDEQ     'Y'                                          UUC102
      *                                                                         UUC102
     C                   MOVE      'N'           XXXXXX            1            UUC102
    ? *                                                                         UUC102
?   ? **   Check if Batch number and Batch item are numeric                     UUC102
     C                   MOVEL     BTNB          NUM1              4 0          UUC102
     C                   MOVEL     BINB          NUM2              4 0          UUC102
     C                   MOVEL     NUM1          ALP1              3            UUC102
     C                   MOVEL     NUM2          ALP2              3            UUC102
      *                                                                         UUC102
     C     BTNB          IFEQ      ALP1                                         UUC102
     C     BINN          ANDEQ     ALP2                                         UUC102
     C     BINN          OREQ      ALP2                                                     MD058751
     C                   MOVE      'Y'           XXXXXX                         UUC102
      **   Read Extended customer informations                                  UUC102
     C     KBTBI         SETLL     GLJENAP0                                     UUC102
     C     KBTBI         READE     GLJENAP0                               76    UUC102
      *                                                                         UUC102
      *  OLD NARRATIVE FROM SWITTI                                              UUC102
      *                                                                         UUC102
     C     *IN76         DOWEQ     '0'                                          UUC102
     C     ZAEXTP        IFEQ      '00'                                         UUC102
     C                   EXSR      ACTION                                       UUC102
    ?C                   ELSE                                                   UUC102
      *  ZAEXTP = "99" : ADDITIONAL INFO (DON'T PRINT)                          UUC102
     C     ZAEXTP        IFNE      '99'                                         UUC102
     C                   EXSR      ACTION                                       UUC102
    ?C                   END                                                    UUC102
    ?C                   END                                                    UUC102
      *                                                                         UUC102
     C     KBTBI         READE     GLJENAP0                               76    UUC102
     C                   END                                                    UUC102
    ?C                   END                                                    UUC102
    ?C                   ELSE                                                   UUC102
     C     UUC102        IFEQ      'Y'                                          UUC102
     C                   MOVE      *BLANKS       CXT0100A         10            UUC102
     C                   EVAL      CXT0100A = PVAL( 2 )                         UUC102
     C                   CALL      CXT0100A                                     UUC102
     C                   PARM                    APOSTX                         UUC102
     C                   PARM                    FTREF                          UUC102
     C     FTREF1        IFNE      ' '                                          UUC102
     C                   MOVEL     FTREF1        ZAEXRF                         UUC102
     C                   EXSR      ACTION                                       UUC102
    ?C                   END                                                    UUC102
     C     FTREF2        IFNE      ' '                                          UUC102
     C                   MOVEL     FTREF2        ZAEXRF                         UUC102
     C                   EXSR      ACTION                                       UUC102
     C     FTREF3        IFNE      ' '                                          UUC102
     C                   MOVEL     FTREF3        ZAEXRF                         UUC102
     C                   EXSR      ACTION                                       UUC102
     C     FTREF4        IFNE      ' '                                          UUC102
     C                   MOVEL     FTREF4        ZAEXRF                         UUC102
     C                   EXSR      ACTION                                       UUC102
     C     FTREF5        IFNE      ' '                                          UUC102
     C                   MOVEL     FTREF5        ZAEXRF                         UUC102
     C                   EXSR      ACTION                                       UUC102
     C     FTREF6        IFNE      ' '                                          UUC102
     C                   MOVEL     FTREF6        ZAEXRF                         UUC102
     C                   EXSR      ACTION                                       UUC102
     C     FTREF7        IFNE      ' '                                          UUC102
     C                   MOVEL     FTREF7        ZAEXRF                         UUC102
     C                   EXSR      ACTION                                       UUC102
     C     FTREF8        IFNE      ' '                                          UUC102
     C                   MOVEL     FTREF8        ZAEXRF                         UUC102
     C                   EXSR      ACTION                                       UUC102
     C     FTREF9        IFNE      ' '                                          UUC102
     C                   MOVEL     FTREF9        ZAEXRF                         UUC102
     C                   EXSR      ACTION                                       UUC102
     C     FTREFA        IFNE      ' '                                          UUC102
     C                   MOVEL     FTREFA        ZAEXRF                         UUC102
     C                   EXSR      ACTION                                       UUC102
    ?C                   END                                                    UUC102
    ?C                   END                                                    UUC102
    ?C                   END                                                    UUC102
    ?C                   END                                                    UUC102
    ?C                   END                                                    UUC102
    ?C                   END                                                    UUC102
    ?C                   END                                                    UUC102
    ?C                   END                                                    UUC102
    ?C                   END                                                    UUC102
    ?C                   END                                                    UUC102
    ?C                   END                                                    UUC102
      *                                                                         UUC102
