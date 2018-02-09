     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Reset Past Due Customer Flag')                *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE004781 - Midas LE Reset Past Due Customer Flag             *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL132             Date 01May13               *
      *                 AR1097467 *CREATE  Date 11Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master (Recompile)                 *
      *  AR1097467A - Expected 15% COB run optimization not met       *
      *                                                               *
      *****************************************************************
      /SPACE
      *****************************************************************
     FSDACUSL6  UF   E           K DISK    INFSR(*PSSR)
 
     D Recursive       S              1A
     D @RTCD           S              7A
     D @OPTN           S              7A
 
     D/COPY ZACPYSRC,PSDS
      ** External Definitions
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local Data Area for Error Log
 
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ** Customer Lending ICD Details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access objects
 
      /EJECT
      *****************************************************************
      * Main Processing                                               *
      *****************************************************************
 
      ** Access Customer Lending ICD Details
 
     C                   CALL      'AOCLNDR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDCLND        PARM      SDCLND        DSSDY
 
      ** If Found, reset Past Due Customer flag
 
     C                   IF        @RTCD = *BLANKS
 
     C                   IF        BPMTDL = 'A'
     C                   READ(E)   SDACUSL6
     C                   DOW       NOT %EOF(SDACUSL6)
     C                   EVAL      E5PDCU = *BLANK
 
     C                   UPDATE(E) SDACUSD0
 
     C                   IF        %ERROR
     C                   EVAL      DBFILE = 'SDACUSL6'
     C                   EVAL      DBKEY  = E5CUST
     C                   EVAL      DBASE  = 010
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   READ(E)   SDACUSL6
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        Recursive = *BLANK
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
