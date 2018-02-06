     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas AO Secondary COB Bank Details')
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOSBNKR0 - Secondary COB Bank Details                        *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD021155           Date 08Jul13               *
      *                 CCB020  *CREATE    Date 06Aug12               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD021155 - COB Restructure Phase 1 remnants                  *
      *           - SDSBNKTD as parameter(not DSSDY)                  *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
      *                                                               *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     D***SDBNK         E DS                  EXTNAME(SDSBNKTD)                              MD021155
     D SDSBNK        E DS                  EXTNAME(SDSBNKTD)                                MD021155
     D PRtcd           S              7
     D POptn           S              7
     D WRun            S              1
     D DSSDY         E DS                  EXTNAME(DSSDY)                                   MD021155

     C     *ENTRY        PLIST
     C                   PARM                    PRtcd
     C                   PARM                    POptn
     C**********         PARM                    SDBNK                                      MD021155
     C                   PARM                    DSSDY                                      MD021155

     C                   IF        POptn = '*FREE  '
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   IF        POptn = '*FIRST '
     C/EXEC SQL
     C**Select***into*:SDBNK*from*SDSBNKTD***********************************               MD021155
     C+ Select * into :SDSBNK from SDSBNKTD                                                 MD021155
     C/END-EXEC
     C                   ENDIF

     C                   IF        SQLCODE <> 0
     C                   EVAL      PRtcd = '*ERROR '
     C                   EXSR      *PSSR
     C                   ELSE                                                               MD021155
     C                   EVAL      DSSDY = SDSBNK                                           MD021155
     C                   ENDIF

     C                   RETURN
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
