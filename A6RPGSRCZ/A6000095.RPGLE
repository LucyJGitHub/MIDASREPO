     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('BA6048 - ensure Setups for BA6048')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  A6000095 - Midas Take on for A6CLIPX0                        *
      *                                                               *
      *  (C) Copyright Finastra International Limited 2023            *
      *                                                               *
      *  Last Amend No. BA6048  *CREATE    Date 28Feb23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BA6048 - New Special Instructions for LE Loans               *
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
     FCLOAN     IF   E           K DISK    IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCLF)
     F                                     IGNORE(CLOANZ1F)
     F                                     INFSR(*PSSR)

     FA6CLIPY0  UF A E           K DISK    INFSR(*PSSR)

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

     C                   READ      CLOAN

     C                   DOU       %EOF(CLOAN)

     C     KCLIPX0       Chain     A6CLIPY0
     C                   If        %FOUND(A6CLIPY0)
     C                   else
     C                   Eval      X0LNRF = LNRF
     C                   Eval      X0SPI4 = *BLANKS
     C                   Eval      X0SP1B = *BLANKS
     C                   Eval      X0SP2B = *BLANKS
     C                   Eval      X0SP3B = *BLANKS
     C                   Eval      X0SP4B = *BLANKS
     C                   Write     A6CLIPD0
     C                   Endif

     C                   READ      CLOAN

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

     C     *ENTRY        PLIST
     C                   PARM                    RTCD              7
     C                   PARM                    MODE              1
     C
     C     KCLIPX0       KLIST
     C                   KFLD                    LNRF

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
     C                   MOVE      '*ERROR '     RTCD
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
(C) Copyright Finastra International Limited 2023
