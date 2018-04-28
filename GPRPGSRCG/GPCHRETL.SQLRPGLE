     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GP Validate Retail Account Number')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPCHRETL - Validate existence of retail number in WIP        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. AR978786 *CREATE   Date 28Jun12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR978786 - Retail number attribution problem                 *
      *             (Child:AR978788)                                  *
      *                                                               *
      *****************************************************************
 
     D  P_MSWAPI       S             32
     D  P_MSWDATA      S          32000    VARYING
     D  P_MSWZONE      S             12
     D  Pos            S              5S 0
     D  WFound         S              1A
     D  WACNO          S             10A
     D  PReturnCode    S              1A
     D  PRetail        S             10A
     D  PZone          S             12A
     D @RUN            S              1A
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    PReturnCode
     C                   PARM                    PRetail
     C                   PARM                    PZone
 
     C                   EVAL      PZone = %TRIM(PZone)
     C/EXEC SQL
     C+ DECLARE UScursor CURSOR FOR
     C+ SELECT MSWAPI, CAST(MSWDATA AS VARCHAR(32000)), MSWZONE
     C+ FROM T_MSWIP WHERE MSWAPI = 'AMAD' AND MSWZONE = :PZone
     C+ AND MSWSTAT = 'TO_AUTHORISE'
     C/END-EXEC
      *
     C/EXEC SQL
     C+ OPEN UScursor
     C/END-EXEC
      *
     C/EXEC SQL
     C+ FETCH NEXT
     C+ FROM UScursor
     C+ INTO :P_MSWAPI, :P_MSWDATA, :P_MSWZONE
     C/END-EXEC
      *
     C                   EVAL      WFound = 'N'
     C     'AMAD.DDACNO>'SCAN      P_MSWDATA:1   Pos
     C                   EVAL      Pos = Pos + 12
     C     P_MSWDATA     IFNE      *BLANKS
     C                   EVAL      WACNO = %SUBST(P_MSWDATA:Pos:10)
     C                   ENDIF
      *
     C                   IF        WACNO = PRetail
     C                   EVAL      WFound = 'Y'
     C                   ENDIF
      *
     C                   DOW       SQLCODE = 0 AND
     C                             WFound = 'N'
      *
     C/EXEC SQL
     C+ FETCH NEXT
     C+ FROM UScursor
     C+ INTO :P_MSWAPI, :P_MSWDATA, :P_MSWZONE
     C/END-EXEC
      *
     C                   EVAL      Pos = 0
     C     'AMAD.DDACNO>'SCAN      P_MSWDATA:1   Pos
     C                   EVAL      Pos = Pos + 12
     C                   EVAL      WACNO = %SUBST(P_MSWDATA:Pos:10)
      *
     C                   IF        WACNO = PRetail
     C                   EVAL      WFound = 'Y'
     C                   ENDIF
      *
     C                   ENDDO
 
     C                   EVAL      PReturnCode = WFound
     C                   EVAL      *INLR = *ON
     C                   RETURN
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
     C     *PSSR         BEGSR
 
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN
     C                   DUMP
 
     C                   ENDIF
 
     C                   SETON                                        U7U8LR
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
