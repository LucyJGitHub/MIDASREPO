      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Password for SWIFT Changes')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000714 - Midas UP Password for SWIFT Changes               *
      *                                                               *
      *  Function:  This program will read through validation list    *
      *             SCSWPSVL (in the Bridge library) and make sure    *
      *             all passwords exist in the system (SCSWPSVL)      *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD060005           Date 10Oct22               *
      *  Prev Amend No. MD059471 *CREATE   Date 10Oct22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060005 - SCSWPSVL is removed from Bridge library after     *
      *           - Applied for MD-60563                              *
      *             database upgrade                                  *
      *  MD059471 - Validation List Password for SWIFT Changes        *
      *           - Applied for MD-60563                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index                                             *
      *                                                               *
      *  *PSSR     - Error processing                                 *
      *  *INZSR    - Initialise                                       *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      * Validation list entries maintenance display file.
     FMESWACTD  IP   E             DISK
      *
      *
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      * Action codes.
     D Insert          C                   CONST('A')
     D Find            C                   CONST('F')
      *
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      *
     D WRun            S              1A

      ** Entry parameters.

     D PValidList      S             10A
     D PLibrary        S             10A
     D BLibrary        S             10A
     D Library         S             10A
     D Error           S              7A
     D PASS            S             16A

      ** UT000033 parameters.

     D PReturnCode     S              7A
     D PAction         S              1A
     D PID             S            100A
     D PPass1          S            600A
     D PPass2          S            600A
     D PDescr          S           1000A
      *
      /EJECT
      *****************************************************************
      * MAIN - Processing
      *****************************************************************

      ** Retrieve Password from BridgeLib/SCSWPSVL

     C                   CALL      'UT000033'
     C                   PARM      *Blanks       PReturnCode
     C                   PARM      Find          PAction
     C**********         PARM      'SCSWPSVL'    PValidList                                 MD060005
     C                   PARM      'SCSWPSVLB'   PValidList                                 MD060005
     C                   PARM      BLibrary      Library
     C                   PARM      SWFEAT        PID
     C     PASS          PARM      *Blanks       PPass1
     C                   PARM      *Blanks       PPass2
     C                   PARM      *Blanks       PDescr

     C                   IF        PReturnCode <> *BLANKS
     C                   EVAL      Error = '*ERROR'
     C                   dump
     C                   seton                                        LR
     C                   return
     C                   Endif

      ** and insert entry in the system validation list

     C                   CALL      'UT000033'
     C                   PARM      *Blanks       PReturnCode
     C                   PARM      Insert        PAction
     C                   PARM      'SCSWPSVL'    PValidList
     C                   PARM      PLibrary      Library
     C                   PARM      SWFEAT        PID
     C                   PARM      PASS          PPass1
     C                   PARM      PASS          PPass2
     C                   PARM      *Blanks       PDescr

     C                   IF        PReturnCode <> *BLANKS
     C                             and PReturnCode <> 'CPF226A'
     C                   EVAL      Error = '*ERROR'
     C                   dump
     C                   seton                                        LR
     C                   return
     C                   Endif

     C   LR              RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Implicitly on Program Activation                  *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Parameters.

     C     *ENTRY        PLIST
     C                   PARM                    BLibrary         10
     C                   PARM                    PFX               2
     C                   PARM                    Error
      *
     C                   EVAL      PLibrary   = PFX + 'DMLIB'
      *
      *
     C     INZSRE        ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically If a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
