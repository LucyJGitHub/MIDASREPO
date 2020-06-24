      *****************************************************************
      *  Start of /COPY LUC110_105                                    *
      *****************************************************************
      *                                                               *
      *  Last Amend No. MD055854 *Create   Date 15Jun20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055854 - When deleting a batch or batch item from frontend *
      *             the narratives in XXJENPX0 file is not deleted    *
      *             Amend to delete corresponding rec in XXJENPX0.    *
      *                                                               *
      *****************************************************************
      *                                                                                     MD055854
      ** Delete batch items in extension file                                               MD055854
      *                                                                                     MD055854
     C     LUC110        IFEQ      'Y'                                                      MD055854
     C                   SETOFF                                       9899                  MD055854
     C     BRBTNB        SETLL     XXJENPY1                           99                    MD055854
     C     *IN99         IFEQ      *OFF                                                     MD055854
     C     BRBTNB        READE     XXJENPY1                               98                MD055854
      *                                                                                     MD055854
     C     *IN98         DOWEQ     *OFF                                                     MD055854
     C                   DELETE    XXJENPY1                                                 MD055854
     C     BRBTNB        READE     XXJENPY1                               98                MD055854
     C                   ENDDO                                                              MD055854
      *                                                                                     MD055854
     C                   ENDIF                                                              MD055854
     C                   SETOFF                                       9899                  MD055854
     C                   ENDIF                                                              MD055854
      *                                                                                     MD055854
      *****************************************************************
      *  End of /COPY LUC110_105                                      *
      *****************************************************************
