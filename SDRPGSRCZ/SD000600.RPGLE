     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Amend Washout Proc Init Pgm')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000600 - Amend Washout Processing Initialization Program   *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL052  *CREATE    Date 02Dec15               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL052 - Amend Washout Processing                            *
      *                                                               *
      *****************************************************************
      ** Midas SD Branch codes
     FSDBRCHL0  IF   E           K DISK
      ** SD Branch Codes Extension Details
     FSDBRAXL1  IF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(X0)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** External DS for Bank Details ICD retrieval
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **----------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** US Treaty Withholding Tax Information Take-on
      *
     C     *LOVAL        SETLL     SDBRCHL0
     C                   READ      SDBRCHL0
     C                   DOW       %EOF = '0'
 
     C     A8BRCD        CHAIN     SDBRAXL1
     C                   IF        Not %Found(SDBRAXL1)
     C                   EVAL      X0A8BRCD = A8BRCD
     C                   EVAL      X0A8ATEY = 'N'
     C                   EVAL      X0ZZ252  = ' '
     C                   WRITE     SDBRCHF0
     C                   ENDIF
 
     C                   READ      SDBRCHL0
     C                   ENDDO
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  -   Program exception error routine                    *
      *            Called automatically if a program error occurs,    *
      *            or directly by the program code using EXSR.        *
      *            This subroutine DUMPs the program just once.       *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
