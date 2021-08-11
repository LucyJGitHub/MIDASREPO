      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Validation List take-on')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000213 - Midas SM Validation List take-on                  *
      *                                                               *
      *  Function:  This program will read through GPPASSPD and       *
      *             create an entry in the validation list for        *
      *             each record.                                      *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD054346 *CREATE   Date 18Jul21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054346 - Switchable Features Password Encryption           *
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
     FGPUPASPD  IP   E             DISK
      *
      *
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     DPSDS            SDS
     D PSExcpType             40     42
      *  Exception number.
     D PSExcpNo               43     46
      * Job name.
     D PSJobName             244    253
      * User name.
     D PSUser                254    263
      *

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      * Action codes.
     D Insert          C                   CONST('A')
     D Modify          C                   CONST('M')
     D Reset           C                   CONST('R')
     D Delete          C                   CONST('D')
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

      * Logical conditions.
     D True            C                   *ON
     D False           C                   *OFF
      *
      * Default ID / password / description length.
     D ID_LEN          C                   100
     D PWD_LEN         C                   100
     D DSC_LEN         C                    50
      * Default column text.
     D ID_TX           C                   'Validation List ID'
      *
     D WRun            S              1A
      *
      * Entry parameters.
     D PValidList      S             10A
     D PLibrary        S             10A
     D Error           S             10A
      *
      *
      * UT00032 parameters.
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
      *
      *
      * No error (ID successfully insert must be displayed).
     C                   CALL      'UT000033'
     C                   PARM      *Blanks       PReturnCode
     C                   PARM      Insert        PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM      P@SARN        PID
     C                   PARM      PASS          PPass1
     C                   PARM      PASS          PPass2
     C                   PARM      *Blanks       PDescr

     C                   IF        PReturnCode <> *BLANKS
     C                             and PReturnCode <> 'CPF226A'
     C                   EVAL      Error = '*ERROR'
     C                   dump
     C                   seton                                        LR
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
      *
      * Parameters.
     C     *ENTRY        PLIST
     C                   PARM                    Library          10
     C                   PARM                    Error
      *
     C                   EVAL      PValidList = 'GPFEATVL'
     C                   EVAL      PLibrary   = Library
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
