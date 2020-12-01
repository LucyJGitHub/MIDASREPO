      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL001425)                              *
      *                                                               *
      *  GLH00410 - Midas GL Retrieve Postings by Network Account     *
      *                                                               *
      *  Last Amend No. UUC103 *CREATE  Date 20Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  UUC103 - Upgrade of CAR UUC061 to BF Midas 2.1               *
      *           UUC061 - SWIFT Statement Enhancement                *
      *                                                               *
      *****************************************************************
      *-----------------------------------------------------------------------
      ** Check if feature UUC103 (Extended narratives) is on                    UUC103
      *-----------------------------------------------------------------------  UUC103
     C                   EVAL      UUC103 = 'N'                                 UUC103
     C                   CALLB     'AOSARDR0'                                   UUC103
     C                   PARM      *BLANKS       P@RTCD                         UUC103
     C                   PARM      '*VERIFY'     P@OPTN                         UUC103
     C                   PARM      'UUC103 '     P@SARD                         UUC103
     C     SCSARD        PARM      SCSARD        DSFDY                          UUC103
                                                                                UUC103
     C                   IF        P@RTCD = *BLANKS                             UUC103
     C                   EVAL      UUC103 = 'Y'                                 UUC103
     C                   ENDIF                                                  UUC103
                                                                                UUC103
     C                   EVAL      SVALK1 = 'FTStmtNarrPgm'                     UUC103
                                                                                UUC103
     C     UUC103        IFEQ      'Y'                                          UUC103
     C                   CALL      'AOSVALR0'                                   UUC103
     C                   PARM                    RTNCDE            7            UUC103
     C                   PARM                    SVALK1           20            UUC103
     C                   PARM                    SVAL1           200            UUC103
     C                   PARM      *BLANK        SVALK2           20            UUC103
     C                   PARM                    SVAL2           200            UUC103
     C                   PARM      *BLANK        SVALK3           20            UUC103
     C                   PARM                    SVAL3           200            UUC103
     C                   PARM      *BLANK        SVALK4           20            UUC103
     C                   PARM                    SVAL4           200            UUC103
     C                   PARM      *BLANK        SVALK5           20            UUC103
     C                   PARM                    SVAL5           200            UUC103
     C                   PARM      *BLANK        SVALK6           20            UUC103
     C                   PARM                    SVAL6           200            UUC103
     C                   PARM      *BLANK        SVALK7           20            UUC103
     C                   PARM                    SVAL7           200            UUC103
     C                   PARM      *BLANK        SVALK8           20            UUC103
     C                   PARM                    SVAL8           200            UUC103
     C                   PARM      *BLANK        SVALK9           20            UUC103
     C                   PARM                    SVAL9           200            UUC103
     C                   PARM      *BLANK        SVALK0           20            UUC103
     C                   PARM                    SVAL10          200            UUC103
      *                                                                         UUC103
     C     RTNCDE        IFNE      *BLANKS                                      UUC103
     C     RTNCDE        ANDNE     '*NRF '                                      UUC103
     C     *LOCK         IN        LDA                                          UUC103
     C                   MOVE      'SCSVLCTD'    DBFILE                         UUC103
     C                   MOVEL     '012'         DBASE                          UUC103
     C                   MOVEL     'SVALKK'      DBKEY                          UUC103
     C                   OUT       LDA                                          UUC103
     C                   EXSR      *PSSR                                        UUC103
     C                   ENDIF                                                  UUC103
      *                                                                         UUC103
     C                   MOVE      *BLANKS       CXT01A           10            UUC103
     C                   MOVEL     SVAL1         CXT01A                         UUC103
      *                                                                         UUC103
     C                   OPEN      GLJENAPD                                     UUC103
      *                                                                         UUC103
     C                   ENDIF                                                  UUC103
      *-------------------------------------------------                        UUC103
      ** Key List to access Extended Narratives GLJENAPD                        UUC103
      *-------------------------------------------------                        UUC103
     C     KBTBI         KLIST                                                  UUC103
     C                   KFLD                    BTNB                           UUC103
     C                   KFLD                    BINB                           UUC103
     C                   KFLD                    PSTD                           UUC103
