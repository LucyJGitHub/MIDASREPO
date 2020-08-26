      *****************************************************************
      *                                                               *
      *  FT0349 - Midas FT Outgoing payments valid. S3 level 2        *
      *                                                               *
      *  Last Amend No. MD056352           Date 20Aug20               *
      *  Prev Amend No. MD055398A          Date 27Feb20               *
      *                 MD055398           Date 20Feb20               *
      *                 ERZ247  *CREATE    Date 22Nov19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056352 - ERZ247: Our commission is not displayed           *
      *  MD055398A-Duplicate 0.00 (ERZ247)                            *
      *  MD055398 -Duplicate 0.00 (ERZ247)                            *
      *  ERZ247 - Field 71F in MT103 for GPI                          *
      *                                                               *
      *****************************************************************
      *                                                                                       ERZ247
     C                   If        ERZ247 = 'Y'                                               ERZ247
     C                   If        @SENT < 5 And IDX = 0 And SDTCH = 'SHA'                    ERZ247
     C                             And WALREADY = 'N'                                ERZ247MD055398A
     C*****                        And SADDC = 'A'                                            ERZ247
      *                                                                                       ERZ247
     C                   Eval      ZFIELD = '0000000000000000'                                ERZ247
     C                   CallB     'ZEDIT'                                                    ERZ247
     C                   Parm                    ZFIELD                                       ERZ247
     C                   Parm                    ZADEC                                        ERZ247
     C                   Move(P)   ZFIELD        WSCHN            12                          ERZ247
     C                                                                                        ERZ247
     C*****              If        @SENT = 1 And SSCH1 <> WSCHN                       ERZ247MD055398
     C                   If        (@SENT = 1 And SSCH1 <> WSCHN) Or                        MD055398
     C*****                        (@SENT = 1 And SSCH1 <> WSCH1 and               MD055398MD055398A
     C                             (@SENT = 1 And                                          MD055398A
     C                              %trim(SSCH1) <> %trim(WSCH1) And                       MD055398A
     C                             WSCH1 <> *Blanks)                                        MD055398
     C                             OR (@SENT = 1 AND WALREADY = 'N')                        MD056352
     C                   Move(P)   ZFIELD        SSCH2                                        ERZ247
     C                   Move      SPCCY         SSCC2                                        ERZ247
     C                   Z-Add     0             WLAST                                        ERZ247
     C                   Z-Add     2             @SENT                                        ERZ247
     C                   MOVEL     'Y'           WALREADY                                   MD056352
     C                   Endif                                                                ERZ247
      *                                                                                       ERZ247
     C*****              If        @SENT = 2 And SSCH2 <> WSCHN                       ERZ247MD055398
     C                   If        (@SENT = 2 And SSCH2 <> WSCHN) Or                        MD055398
     C*****                        (@SENT = 2 And SSCH2 <> WSCH2 And               MD055398MD055398A
     C                             (@SENT = 2 And                                          MD055398A
     C                              %trim(SSCH2) <> %trim(WSCH2) And                       MD055398A
     C                             WSCH2 <> *Blanks)                                        MD055398
     C                             OR (@SENT = 2 AND WALREADY = 'N')                        MD056352
     C                   Move(P)   ZFIELD        SSCH3                                        ERZ247
     C                   Move      SPCCY         SSCC3                                        ERZ247
     C                   Z-Add     0             WLAST                                        ERZ247
     C                   Z-Add     3             @SENT                                        ERZ247
     C                   MOVEL     'Y'           WALREADY                                   MD056352
     C                   Endif                                                                ERZ247
      *                                                                                       ERZ247
     C*****              If        @SENT = 3 And SSCH3 <> WSCHN                       ERZ247MD055398
     C                   If        (@SENT = 3 And SSCH3 <> WSCHN) Or                        MD055398
     C*****                        (@SENT = 3 And SSCH3 <> WSCH3 And               MD055398MD055398A
     C                             (@SENT = 3 And                                          MD055398A
     C                              %trim(SSCH3) <> %trim(WSCH3) And                       MD055398A
     C                             WSCH3 <> *Blanks)                                        MD055398
     C                             OR (@SENT = 3 AND WALREADY = 'N')                        MD056352
     C                   Move(P)   ZFIELD        SSCH4                                        ERZ247
     C                   Move      SPCCY         SSCC4                                        ERZ247
     C                   Z-Add     0             WLAST                                        ERZ247
     C                   Z-Add     4             @SENT                                        ERZ247
     C                   MOVEL     'Y'           WALREADY                                   MD056352
     C                   Endif                                                                ERZ247
      *                                                                                       ERZ247
     C*****              If        @SENT = 4 And SSCH4 <> WSCHN                       ERZ247MD055398
     C                   If        (@SENT = 4 And SSCH4 <> WSCHN) Or                        MD055398
     C*****                        (@SENT = 4 And SSCH4 <> WSCH4 And               MD055398MD055398A
     C                             (@SENT = 4 And                                          MD055398A
     C                              %trim(SSCH4) <> %trim(WSCH4) And                       MD055398A
     C                             WSCH4 <> *Blanks)                                        MD055398
     C                             OR (@SENT = 4 AND WALREADY = 'N')                        MD056352
     C                   Move(P)   ZFIELD        SSCH5                                        ERZ247
     C                   Move      SPCCY         SSCC5                                        ERZ247
     C                   Z-Add     0             WLAST                                        ERZ247
     C                   Z-Add     5             @SENT                                        ERZ247
     C                   MOVEL     'Y'           WALREADY                                   MD056352
     C                   Endif                                                                ERZ247
      *                                                                                       ERZ247
     C                   Endif                                                                ERZ247
     C                   IF        WALREADY = 'Y'                                           MD056352
     C                   MOVEL     WPREFM1       WPREFM2                                    MD056352
     C                   ENDIF                                                              MD056352
     C                   Endif                                                                ERZ247
      *                                                                                       ERZ247
