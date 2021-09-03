      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL001416)                              *
      *                                                               *
      *  GLH00397 - Midas GL Retrieve Shadow Post. by Network Account *
      *                                                               *
      *  Last Amend No. MD058751        Date 03Sep21                  *
      *  Prev Amend No. UUC103 *CREATE  Date 20Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058751 - Missing tag :86: on MT940s as not extracted by    *
      *             CAR UUC103. Alphanumeric batch numbers not        *
      *             checked correctly.                                *
      *  UUC103 - Upgrade of CAR UUC061 to BF Midas 2.1               *
      *           UUC061 - SWIFT Statement Enhancement                *
      *                                                               *
      *****************************************************************
     C                   MOVEL     *BLANKS       WKEXRF           35            UUC103
     C                   EVAL      ZAEXR1 = *BLANKS                             UUC103
     C                   MOVEL     NRTD          NARRAT                         UUC103
     C                   Z-ADD     1             TOTL              1 0          UUC103
     C                   IF        @DTA = '#'                                   UUC103
     C                             AND UUC103 ='Y'                              UUC103
     C                   MOVEL     BTNB          NUM1              4 0          UUC103
     C                   MOVEL     BINB          NUM2              4 0          UUC103
     C                   MOVEL     NUM1          ALP1              3            UUC103
     C                   MOVEL     NUM2          ALP2              3            UUC103
     C                   IF        BTNB = ALP1                                  UUC103
     C                             AND BINN = ALP2                              UUC103
     C                             OR BINN = ALP2                                           MD058751
     C     KBTBI         SETLL     GLJENAP0                                     UUC103
     C     KBTBI         READE     GLJENAP0                               89    UUC103
     C                   DOW       *IN89 = '0'                                  UUC103
      *                                                                         UUC103
      *  Old narrative from SWITI                                               UUC103
      *                                                                         UUC103
     C                   IF        UUC103 <> 'Y'                                UUC103
      *                                                                         UUC103
     C                   IF        ZAEXTP = '00'                                UUC103
     C                   EXSR      ACTION                                       UUC103
     C                   ELSE                                                   UUC103
     C                   IF        ZAEXTP <> '99'                               UUC103
     C                   EXSR      ACTION                                       UUC103
     C                   ENDIF                                                  UUC103
     C                   ENDIF                                                  UUC103
      *                                                                         UUC103
      ** When UUC103 is on, the extended narratives should be concatenated      UUC103
      ** into the 6 available SWIFT lines                                       UUC103
      *                                                                         UUC103
     C                   ELSE                                                   UUC103
      *                                                                         UUC103
     C                   IF        ZAEXTP <> '99'                               UUC103
      *                                                                         UUC103
     C                   IF        %Subst(ZAEXRF:1:1) = '-' OR                  UUC103
     C                             %Subst(ZAEXRF:1:1) = ':'                     UUC103
     C                   MOVEL     ' '           ZAEXRF                         UUC103
     C                   ENDIF                                                  UUC103
      *                                                                         UUC103
     c                   IF        %subst(WKEXRF:35:1) = ' '                    UUC103
     C                   EVAL      GLExtNarr = %Trim(GLExtNarr) + ' ' + ZAEXRF  UUC103
     c                   ELSE                                                   UUC103
     c                   EVAL      GLExtNarr = %Trim(GLExtNarr) +  ZAEXRF       UUC103
     C                   ENDIF                                                  UUC103
      * Make sure first char is not blank                                       UUC103
     c                   EVAL      GLExtNarr = %Trim(GLExtNarr)                 UUC103
      *                                                                         UUC103
     c                   MOVEL     ZAEXRF        WKEXRF                         UUC103
      *                                                                         UUC103
     C                   ENDIF                                                  UUC103
      *                                                                         UUC103
     C                   ENDIF                                                  UUC103
                                                                                UUC103
     C     KBTBI         READE     GLJENAP0                               89    UUC103
     C                   END                                                    UUC103
      *                                                                         UUC103
     C                   IF        UUC103 = 'Y'                                 UUC103
     C                   EVAL      TOTL = %Len(%Trim(GLExtNarr)) / 65           UUC103
      *                                                                         UUC103
     C                   IF        (TOTL * 65) < %Len(%Trim(GLExtNarr))         UUC103
     C                   ADD       1             TOTL                           UUC103
     C                   ENDIF                                                  UUC103
      *                                                                         UUC103
     C                   ENDIF                                                  UUC103
      *                                                                         UUC103
     C                   END                                                    UUC103
     C                   END                                                    UUC103
                                                                                UUC103
