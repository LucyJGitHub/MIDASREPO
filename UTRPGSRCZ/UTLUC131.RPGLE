     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas Take on for XXSWACX0')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  UTLUC131 - Midas Take on for XXSWACX0                        *
      *                                                               *
      *  (C) Copyright Finastra International Limited 2019            *
      *                                                               *
      *  Last Amend No. LUC131  *Create    Date 08Aug19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE090 - Midas SOAR/CARS Interface                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR     - Error processing                                 *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas SWIFT Accounts
     FSWACS     IF   E           K DISK    IGNORE(SWACSSAF:SWACSSCF)
     F                                     INFSR(*PSSR)

     FXXSWACY0  UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(X)

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D @RUN            S              1A

      **---------------------------------------------------------------
      ** Standard D-specs
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      ** External DS for RUNDAT DataArea Layout file
     D RUNDTA        E DS                  EXTNAME(RUNDAT)

      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *****************************************************************
      /EJECT
      *****************************************************************

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************


     C                   DOU       %EOF(SWACS)
     C                   READ      SWACS

     C     KSWACX0       Chain     XXSWACY0
     C                   If        %FOUND(XXSWACY0)
     C                   else
     C                   Eval      XRECI = RECI
     C                   Eval      XNCNUMA = CNUMA
     C                   Eval      XNCCY = CCY
     C                   Eval      XNACOD = ACOD
     C                   Eval      XNACSQ = ACSQ
     C                   Eval      XNBRCA = BRCA
     C                   Eval      XDLSR = 'N'
     C                   Eval      XSOAR = 'N'
     C                   Write     XXSWACBF
     C                   Endif

     C                   ENDDO

     C                   EVAL      *INLR = *ON

     C                   RETURN
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     KSWACX0       KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUMA
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ

      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error
     C                   IF        @RTCD <> *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(C) Copyright Finastra International Limited 2019
