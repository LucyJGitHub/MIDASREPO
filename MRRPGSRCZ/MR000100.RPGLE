/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MR Access Historic Currency Rates')
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MR000100 -  Access Historic Currency Rates                   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CMR001             Date 01Sep04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CMR001 - MidasPlus Reporting                                 *
      *                                                               *
      *****************************************************************
 
     FSDCUHSL2  IF   E           K DISK    INFSR(*PSSR)
 
      * Maximum number of rates
     D MaxNoRats       C                   CONST(1000)
 
      * Currency/Date
     D #_CYDT          S              8    DIM(MaxNoRats)
      * Rate Details
     D #_RATEDT        S             14    DIM(MaxNoRats)
 
      * Historic Rate Details
     D SDCUHS        E DS                  EXTNAME(SDCUHSPD)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
     C                   PARM                    SDCUHS
 
      * Use input fields
 
     C                   MOVEL     I#CCY         G2CYCD
     C                   Z-ADD     I#DATE        G2HIDT
 
     C                   MOVEL     G2CYCD        CYDT              8
     C                   MOVE      G2HIDT        CYDT
 
      * If currency is base currency
      *  pass back a rate of 1
 
     C     G2CYCD        IFEQ      BJCYCD
     C                   Z-ADD     1             G2SPRT
     C                   MOVE      'M'           G2MDIN
     C                   ELSE
 
      * If the rate was previously accessed,
      * use that rate details
 
     C                   Z-ADD     1             @IX               6 0
     C     CYDT          LOOKUP    #_CYDT(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     #_RATEDT(@IX) SDCUHS
     C                   ELSE
 
      * Access the rate
 
     C                   Z-ADD     0             G2SPRT
     C                   MOVE      'M'           G2MDIN
 
     C     CUHSK         CHAIN     SDCUHSL2                           99
 
      * If not found, get the rate prior to this date
 
     C     *in99         IFEQ      '1'
     C     CUHSK         SETLL     SDCUHSL2
     C     CUHSKP        READE     SDCUHSL2                               99
     C                   ENDIF
 
      * Save the rate details
 
     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_CYDT(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     CYDT          #_CYDT(@IX)
     C                   MOVEL     SDCUHS        #_RATEDT(@IX)
     C                   ELSE
     C                   ADD       1             @CIX
     C                   MOVEL     CYDT          #_CYDT(@CIX)
     C                   MOVEL     SDCUHS        #_RATEDT(@CIX)
     C     @CIX          IFEQ      MaxNoRats
     C                   Z-ADD     *ZERO         @CIX
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      * Return
 
     C                   RETURN
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   Z-ADD     *ZERO         @CIX              6 0
      *
     C     CUHSKP        KLIST
     C                   KFLD                    G2CYCD
     C     CUHSK         KLIST
     C                   KFLD                    G2CYCD
     C                   KFLD                    G2HIDT
      *
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
     C     *PSSR         BEGSR
 
     C     W#RUN         IFEQ      *BLANKS
 
     C                   MOVE      'Y'           W#RUN             1
 
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
 
     C                   DUMP
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
