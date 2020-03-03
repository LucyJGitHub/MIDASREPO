      *****************************************************************
      *                                                               *
      *  FTVSCHG   - Validate OP Sender's Charges                     *
      *                                                               *
      *  Last Amend No. ERZ247  *CREATE    Date 22Nov19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  ERZ247 - Field 71F in MT103 for GPI                          *
      *                                                               *
      *****************************************************************
      *                                                                                     ERZ247
      ** Access SAR details file to determine if ERZ247 enhancement is                      ERZ247
      ** switched on.                                                                       ERZ247
     C                   CALL      'AOSARDR0'                                               ERZ247
     C                   PARM      '*BLANKS'     @RTCD             7                        ERZ247
     C                   PARM      '*VERIFY'     @OPTN             7                        ERZ247
     C                   PARM      'ERZ247'      @SARD             6                        ERZ247
     C     SCSARD        PARM      SCSARD        DSFDY                                      ERZ247
      *                                                                                     ERZ247
     C                   IF        (@RTCD <> *Blanks) And (@RTCD <> '*NRF   ')              ERZ247
     C                   MOVEL     'SCSARDPD'    DBFILE                                     ERZ247
     C                   Z-ADD     4             DBASE                                      ERZ247
     C                   MOVEL     'ERZ247'      DBKEY                                      ERZ247
     C                   EXSR      *PSSR                                                    ERZ247
     C                   ENDIF                                                              ERZ247
      *                                                                                     ERZ247
     C                   IF        @RTCD = *BLANKS                                          ERZ247
     C                   MOVEL     'Y'           ERZ247                                     ERZ247
     C                   ELSE                                                               ERZ247
     C                   MOVEL     'N'           ERZ247                                     ERZ247
     C                   ENDIF                                                              ERZ247
      *                                                                                     ERZ247
