     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GL Extension Table Delete Handler')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000020 - Midas GL Extension Table Delete Handler           *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 263384  *Create    Date 22Jan10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  263384 - Batch Input Error. Applied fix 249259 and 251718:   *
      *           Create a GL Extension Table Delete handler for      *
      *           Journal Entry                                       *
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

      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      *
      ** Local Data Area Data Structure
      *
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)

      *
      ** Copyright Statement Array
      *
     D CPY@            S             80A   DIM(1) CTDATA

      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      *
      ** Entry Parameters
      *
     D PRetCode        S              7A

      *
      ** Key Fields
      *

      *
      ** Delete Counter to prevent failing SQL Delete statement
      *
     D DelCTR          S              9s 0

      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *
      ** Make sure that record exist in the file before deletion
      *
     C                   EVAL      SQLCOD = *Zero
     C                   EVAL      DelCTR = *Zero
      *
     C/EXEC SQL
     C+ SELECT COUNT(*) INTO :DelCTR FROM T_GZBITHEX
     C+ WHERE ZONE = :O#ZONE
     C/END-EXEC
      *
      ** Delete All records from the zone.
      *
     C                   IF        DelCTR > *Zero
     C/EXEC SQL
     C+ DELETE FROM T_GZBITHEX
     C+ WHERE ZONE = :O#ZONE
     C/END-EXEC
     C                   ENDIF
      *
     C                   If        SQLCOD <> *Zero
     C                   Exsr      *PSSR
     C                   Endif
      *
     C                   EVAL      SQLCOD = *Zero
     C                   EVAL      DelCTR = *Zero
      *
     C/EXEC SQL
     C+ SELECT COUNT(*) INTO :DelCTR FROM T_GZBITPEX
     C+ WHERE ZONE = :O#ZONE
     C/END-EXEC
      *
     C                   IF        DelCTR > *Zero
     C/EXEC SQL
     C+ DELETE FROM T_GZBITPEX
     C+ WHERE ZONE = :O#ZONE
     C/END-EXEC
     C                   ENDIF
      *
     C                   If        SQLCOD <> *Zero
     C                   Exsr      *PSSR
     C                   Endif
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   EVAL      PRetCode = '*ERROR '

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   DUMP

     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PRetCode

     C                   EXSR      SRZONE

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZONE - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRZONE        BEGSR

     C                   MOVEL     *BLANK        I#RTCD            7
     C                   MOVEL     *BLANK        I#ERMS           50
      *
      ** Get Zone
      *
     C                   CALL      'GOGETZONE'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      *
      ** INPUTS
      *
     C                   PARM      'N'           I#FULLCHECK       1
      *
      ** OUTPUTS
      *
     C                   PARM                    O#ZONE           10
     C                   PARM                    O#SHTC            4
     C                   PARM                    O#RDNB            5 0
     C                   PARM                    O#DNWD            5 0
     C                   PARM                    O#BCCY            3
     C                   PARM                    O#NJOB            1 0
      *
      ** Error detected  (*PSSR will end the program)
      *
     C     I#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN GOGETZONE'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** No Zone
      *
     C     O#ZONE        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'NO ZONE PRESENT'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2010
