     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas FN Retrieve TDRF From Tradsd using FRNT')        *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  A1008007  - Midas FN Retrieve TDRF From Tradsd using FRNT    *
      *                                                               *
      *  Function:  This program retrieve TDRF From TRADSD using FRNT *
      *  Called By: A1008002 and xx008006                             *
      *                                                               *
      *  (c) Finastra Internationl Limited 2021                       *
      *                                                               *
      *  Last Amend No. BA1008   *CREATE   Date 03Jun21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BA1008 - Replication of Trades to consolidated Branches      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
      *    99         Found Action Code Record                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** Dynamic SQL statement work field
     D WSTRSQL         S           1000A   INZ(*BLANKS)
      *
     D Traderef        S              6
     D FRNkey          S             20
     D Branch          S              3
     D ReturnCodex     S              7
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
      ** Data Area giving Installation Control Details

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     DDSSDY          E DS


      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  LDA

      *
     C/EXEC SQL
     C+ select TDRF into :Traderef  from TRADSD
     C+ where
     C+   TDBA   = :Branch
     C+ and FRNT = :FRNkey                                                                  AR989143
     C/END-EXEC                                                                             AR989143
      *                                                                                     AR989143
     C                   Eval      ReturnCodex = *Blanks
     C                   IF        SQLCOD = 100
     C                   MOVEL     'NRF'         ReturnCodex
     C                   Endif
     C                   IF        SQLCOD <> 0  And SQLCOD <> 100  and
     C                             SQLCOD <> -802
     C                   MOVEL     'RPGETRADFO'  DBPGM
     C                   MOVEL     'TRADSD    '  DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     FRNkey        DBKEY
     C                   MOVEL     'ERR'         ReturnCodex
     C                   DUMP
      *
     C                   ENDIF
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *entry        PLIST
     C                   PARM                    FRNkey
     C                   PARM                    Branch
     C                   PARM                    Traderef
     C                   PARM                    ReturnCodex

     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
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
      *
