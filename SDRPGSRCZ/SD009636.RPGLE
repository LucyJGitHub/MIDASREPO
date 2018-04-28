     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Initialize Link type table')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009636 - Initialization Program to create valid Link type  *
      *                                                               *
      *  Function: This program creates Three valid Link types        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG22521           Date 25Mar09               *
      *                 CER047  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22521 - Cannot navigate to Link Types Maintenance         *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRWriteDet - Subroutine to write Valid Link Types            *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ***Midas*Authority*Types*Update*Index                                                 BUG22521
      ** Midas Link Types Update Index                                                      BUG22521
      *
     F***SDAUTPL0  UF A E           K DISK    INFSR(*PSSR)                                  BUG22521
     FSDLINKL0  UF A E           K DISK    INFSR(*PSSR)                                     BUG22521
     F                                     COMMIT
      ****************************************************************
      /EJECT
      ****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBfile
      **       Defines:                     142 170 DBkey
      **                                    171 180 DBpgm
      **                                    181 1830DBase
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Externally described DS
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PRtcd           S              7A
     D POptn           S              7A
     D PGenerr         S              1A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  MAIN - Processing                                            *
      *****************************************************************
      *
     C                   EXSR      SRWriteDet
     C                   COMMIT
     C                   EVALR     *INLR = *ON
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWriteDet - Subroutine to write Valid Link Types            *
      *                                                               *
      *  Called by: MAIN processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SRWriteDet    BEGSR
      *
      ** Write Details for VB
      *
     C**********         EVAL      AUATYP = 'VB'                                            BUG22521
     C**********         EVAL      AUDESC = 'Authority Holder'                              BUG22521
     C**********         EVAL      AULCHD = BJRDNB                                          BUG22521
     C**********         EVAL      AUCHTP = 'I'                                             BUG22521
     C**********         WRITE     SDAUTPD0                                                 BUG22521
      *                                                                                     BUG22521
     C                   EVAL      LKLTYP = 'VB'                                            BUG22521
     C                   EVAL      LKDESC = 'Authority Holder'                              BUG22521
     C                   EVAL      LKLCHD = BJRDNB                                          BUG22521
     C                   EVAL      LKCHTP = 'I'                                             BUG22521
     C                   WRITE     SDLINKD0                                                 BUG22521
      *
      ** Write Details for WB
      *
     C**********         EVAL      AUATYP = 'WB'                                            BUG22521
     C**********         EVAL      AUDESC = 'Commercial Owner'                              BUG22521
     C**********         EVAL      AULCHD = BJRDNB                                          BUG22521
     C**********         EVAL      AUCHTP = 'I'                                             BUG22521
     C**********         WRITE     SDAUTPD0                                                 BUG22521
      *                                                                                     BUG22521
     C                   EVAL      LKLTYP = 'WB'                                            BUG22521
     C                   EVAL      LKDESC = 'Commercial Owner'                              BUG22521
     C                   EVAL      LKLCHD = BJRDNB                                          BUG22521
     C                   EVAL      LKCHTP = 'I'                                             BUG22521
     C                   WRITE     SDLINKD0                                                 BUG22521
      *
      ** Write Details for OW
      *
     C**********         EVAL      AUATYP = 'OW'                                            BUG22521
     C**********         EVAL      AUDESC = 'Account Owner'                                 BUG22521
     C**********         EVAL      AULCHD = BJRDNB                                          BUG22521
     C**********         EVAL      AUCHTP = 'I'                                             BUG22521
     C**********         WRITE     SDAUTPD0                                                 BUG22521
      *                                                                                     BUG22521
     C                   EVAL      LKLTYP = 'OW'                                            BUG22521
     C                   EVAL      LKDESC = 'Account Owner'                                 BUG22521
     C                   EVAL      LKLCHD = BJRDNB                                          BUG22521
     C                   EVAL      LKCHTP = 'I'                                             BUG22521
     C                   WRITE     SDLINKD0                                                 BUG22521
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR - Program exception error routine                       *
      *         Called automatically if a program error occurs,       *
      *         or directly by the program code using EXSR.           *
      *         This subroutine DUMPs the program just once.          *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   DUMP
     C                   EVAL      PGenerr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Define Data Area
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Initialise fields
      *
     C                   EVAL      DBase  = *ZEROS
     C                   EVAL      DBfile = *BLANKS
     C                   EVAL      DBkey  = *BLANKS
     C                   EVAL      DBproc = *BLANKS
      *
      ** Get info from the AOBANKR0
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG'        PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSSDY
      *
      ** If error, then do
      *
     C                   IF        PRtCd <> *BLANKS
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBfile = 'SDBANKPD'
     C                   EVAL      DBase  = 01
     C                   EVAL      DBkey  = 'CER047'
     C                   EVAL      DBpgm  = 'SD009636'
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   ENDSR
      *==============================================================*
