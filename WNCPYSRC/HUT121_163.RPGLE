      *****************************************************************
      *                                                               *
      *  HUT121_163 - Midas /COPY for GPPRICED                        *
      *                                                               *
      *  Last Amend No. HUT121C            Date 29Apr22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT121C -  Allow SE Price Input for Non-working day          *
      *                                                               *
      *****************************************************************
     C                   MOVEL     ' '           CPRICE                                      HUT121C
     C     *IN99         IFEQ      '1'                                                       HUT121C
     C     HUT121        ANDEQ     'Y'                                                       HUT121C
     C     I#BIMG        ANDNE     *BLANKS                                                   HUT121C
      *                                                                                      HUT121C
      ** Check without value date                                                            HUT121C
      *                                                                                      HUT121C
     C     K_GZPRICEL1   SETLL     PRICEDF                            99                     HUT121C
     C     K_GZPRICEL1   CHAIN     PRICEDF                            99                     HUT121C
     C     *IN99         IFEQ      '0'                                                       HUT121C
     C                   MOVEL     'Y'           CPRICE            1                         HUT121C
     C                   ENDIF                                                               HUT121C
     C                   ENDIF                                                               HUT121C
