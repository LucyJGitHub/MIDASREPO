     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE PDCL remove records from FACACT')             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE007053 - Past Due Call Loan maturity                       *
      *                                                               *
      *  Function: This function deletes records from FACACT when they*
      *            don't have a corresponding record on FCLTYFM.      *
      *            Called by LEC07016.                                *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR596051 *CREATE   Date 31Jul10               *
      *                 XXXXXX             Date NNXxxNN               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR596051 - Delete from FACACT records that don't have a      *
      *             corresponding Facility record                     *
      *                                                               *
      *****************************************************************
     F/SPACE
      *****************************************************************
    ?FFACACT    UF   E           K DISK    INFSR(*PSSR)
     FFCLTYL1   IF   E           K DISK    INFSR(*PSSR)
     FPEFCLFL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:PEFFCLTY)
      *****************************************************************
     D/EJECT
      *
      *----------------------------------------------------------------
      ** Passed Parameters
      *
      *----------------------------------------------------------------
      ** Overlays
     D                 DS                                                       Fwd Drw Days
      *----------------------------------------------------------------
      ** External Definitions
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
     D/COPY ZACPYSRC,PSDS
      *
     D/COPY ZACPYSRC,PROCPARMS
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access objects.
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access objects.
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Initial Process
     C                   EXSR      srInit
      *
      *----------------------------------------------------------------
      *
      ** Process FACACT
      *
     C                   READ(E)   FACACT
      *
     C                   DOW       NOT %EOF(FACACT)
      *
      ** Chain FCLTY
     C                   MOVEL     FCFCTY        @FTYP             3 0
     C                   MOVE      FCFCTY        @FSEQ             2 0
     C     KEY001        CHAIN(E)  FCLTYL1
     C                   IF        NOT %FOUND(FCLTYL1)
     C     KEY001        CHAIN(E)  PEFCLFL1
     C                   IF        NOT %FOUND(PEFCLFL1)
      *
      ** If record not found, delete from FACACTF
      *
     C                   DELETE    FACACTF
      *
     C                   END
      *
     C                   END
      *
     C                   READ(E)   FACACT
     C                   ENDDO
      *----------------------------------------------------------------
      ** Terminate Program
      *
     C                   EVAL      *INLR       = *ON
     C                   RETURN
      *****************************************************************
     C/EJECT
     C     srInit        BEGSR
      *****************************************************************
      *
      ** Key to access facility file
     C     KEY001        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    FCCNUM
     C                   KFLD                    @FTYP
     C                   KFLD                    @FSEQ
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        @RTCD      <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE      = 'SDBANKPD'
     C                   EVAL      DBKEY       = '*FIRST'
     C                   EVAL      DBASE       = 021
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *****************************************************************
     C                   ENDSR
     C/COPY ZACPYSRC,PSSR_ILEB
      *
     C/EJECT
**  CPY@
(c) Finastra International Limited 2010
