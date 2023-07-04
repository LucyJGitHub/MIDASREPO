     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited')
      ********************************************************************
/*STD *  RPGSQLBND                                                       *
/*EXI *  TEXT('Midas LE Reorganise A6CLIPX0')                            *
      ********************************************************************
      *                                                                  *
      *  Midas  -  Lending Module                                        *
      *                                                                  *
      *  A6000096 - Reorganise extension file                            *
      *                                                                  *
      *  (C) Copyright Finastra International Limited 2023               *
      *                                                                  *
      *  Last Amend No. BA6048  *CREATE    Date 28Feb23                  *
      *                                                                  *
      *------------------------------------------------------------------*
      *                                                                  *
      *  BA6048 - New Special Instructions for LE Loans                  *
      *                                                                  *
      ********************************************************************
      /EJECT
      *****************************************************************
      *
      *****************************************************************
      /SPACE
      *****************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement.
      *
     D PSDS           SDS
      ** Program Status Data Structure
     D  PGM              *PROC
     D  JOB                  244    253
     D  USER                 254    263
      **  Local data area for data base errors.
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data structure used for access objects
      *
     D WRun            S              1    INZ(*Blanks)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            MAIN     - Control Processing.                     *
      *                                                               *
      *****************************************************************
      *
      ** Initial processing
     C                   ExSR      #IINIT
      *
      ** Process reorganisation
     C                   ExSR      #IREOR
      *
      ** End program
     C                   ExSR      #IEXIT
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IINIT   - Initial Processing.                     *
      *                                                               *
      *****************************************************************
     C     #IINIT        BEGSR
      *                                                               *
      ** Check if SAR BA6048 is switched on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'BA6048'      @SARD             6
     C                   PARM                    DSFDY
      *
     C     @RTCD         IfNE      *BLANKS
     C                   ExSR      #IEXIT
     C                   EndIf
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IREOR   - File reorganisation                     *
      *                                                               *
      *****************************************************************
     C     #IREOR        BEGSR
      *
      * Delete extension records when not in MCLONCL (matured
      * loans) / CLOANCL
      *
     C/EXEC SQL
     C+ delete a6clipx0
     C+ where x0lnrf in (
     C+     select a.x0lnrf from a6clipx0 a
     C+     left join MCLONCL b on a.x0lnrf = b.lnrf
     C+     left join CLOANCL c on a.x0lnrf = c.lnrf
     C+     where b.lnrf is null and c.lnrf is null
     C+ )
     C/END-EXEC

     C                   If        SQLCODE <> 0 AND SQLCODE <> 100
     C                   ExSR      *PSSR
     C                   EndIf

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IEXIT   - Exit the program.                       *
      *                                                               *
      *                                                               *
      * CALLED BY            Main processing.
      *            #ISCRD -  Screen display processing.               *
      *                                                               *
      ********************************************************************
     C     #IEXIT        BEGSR
      *
     C                   Move      *ON           *INLR
     C                   Return
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR

     C                   If        WRun = *BLANKS
     C                   Eval      WRun = 'Y'
     C                   Dump
     C                   Endif

     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Eval      *INLR = *ON
      *
     C                   Return
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(C) Copyright Finastra International Limited 2023
