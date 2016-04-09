     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*XBIF*  OVRDBF FILE(AFFDL01) TOFILE(UPAFFDL0) SHARE(*NO)             *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Compare file fields - maintenance')           *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP009001 - Compare file fields - maintenance                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CUP021  *CREATE    Date 11Jan11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP021 - Rewrite of Action File processing                   *
      *                                                               *
      *****************************************************************
      *
     FUP009001DFCF   E             WORKSTN
     FAFFDL01   UF   E           K DISK
      *
     D UPAFFD        E DS                  EXTNAME(UPAFFDPD)
      * Field attributes.
      *
     D ReturnCode      S              7
     D ErrorMsg        S             30
     D WINKC           S              1
     D WINKL           S              1
     D WPGM            S             10
     D Recursive       S              1
     D ZAPGMQ          S             10
     D ZAPGRL          S              5
     D ZAMSID          S              7
     D ZAMSGF          S             10    INZ('UTMSGF')
     D ZAMSDA          S            132
     D ZAMSTP          S              7
      *
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    ErrorMsg
     C                   PARM                    UPAFFD
     C                   PARM                    WINKC
     C                   PARM                    WINKL
      *
      * Get export format field.
     C                   EXSR      GetExFmtFld
      *
      * Display screen until F3, F6, or F12 taken.
     C     *INKC         DOWEQ     '0'
     C     *INKF         ANDEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      DispScreen
     C                   END
      *
      * Pass back function keys taken.
     C                   MOVE      *INKC         WINKC
     C                   MOVE      *INKL         WINKL
      *
      * End of program.
     C                   SETON                                        LR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Display subfile screen                                        *
      *                                                               *
      *****************************************************************
     C     DispScreen    BEGSR
      *
      * Write detail screen and foooter.
     C                   TIME                    DDTIME
     C                   WRITE     UP009001C2
     C                   WRITE     UP009001F1
      *
      * Read detail screen.
     C                   WRITE     UP009001F0
     C                   READ      UP009001F0                             99
      *
      * Clear the message queue and initial error indicators.
     C                   EXSR      ClearMsgQ
      *
      * If F3 and F12 were not taken.
     C     *INKC         IFEQ      '0'
     C     *INKL         ANDEQ     '0'
      *
      * Validate the screen.
     C                   CAS                     ValScreen
     C                   ENDCS
      *
     C                   ENDIF
      *
     C     DispScreenE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Clear the message queue and initial error indicators.         *
      *                                                               *
      *****************************************************************
     C     ClearMsgQ     BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      WPGM          ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
      *
     C                   MOVEA     '0'           *IN(50)
     C                   MOVEA     '0000000000'  *IN(10)
      *
     C     ClearMsgQE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Validate the screen                                           *
      *                                                               *
      *****************************************************************
     C     ValScreen     BEGSR
      *
      * If any fields are in error, set off F6 if it was taken (i.e. updates
      *  can't be done).
     C     *IN50         IFEQ      '1'
     C                   MOVE      '0'           *INKF
     C                   ENDIF
      *
      * Update the primary record
     C     *INKF         CASEQ     '1'           UpdPrimRec
     C                   ENDCS
 
     C     ValScreenE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Update the primary record.                                    *
      *                                                               *
      *****************************************************************
     C     UpdPrimRec    BEGSR
 
     C     UPAFFDK       CHAIN     AFFDL01                            99
     C                   EVAL      AFKEYF = DDKEYF
     C                   EVAL      AFIGNC = DDIGNC
     C                   EVAL      AFDIFF = DDDIFF
     C                   EVAL      AFIGNU = DDIGNU
     C     *IN99         IFEQ      '0'
     C                   UPDATE    UPAFFDD0
     C                   ENDIF
 
     C     UpdPrimRecE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Get export format field.                                      *
      *                                                               *
      *****************************************************************
     C     GetExFmtFld   BEGSR
      *
     C     UPAFFDK       CHAIN     AFFDL01                            60
     C     *IN60         IFEQ      '1'
     C                   EVAL      ErrorMsg = 'Missing record(s) on UPAFFDPD'
     C                   EXSR      *PSSR
     C                   ELSE
      *
      * Set up fields for display.
     C                   EVAL      DDKEYF = AFKEYF
     C                   EVAL      DDIGNC = AFIGNC
     C                   EVAL      DDDIFF = AFDIFF
     C                   EVAL      DDIGNU = AFIGNU
     C                   ENDIF
      *
     C     GetExFmtFldE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Send a message.                                               *
      *                                                               *
      *****************************************************************
     C     SendMsg       BEGSR
      *
     C                   CALL      'Y2SNMGC'                            0909
     C                   PARM      WPGM          ZAPGMQ
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
      *
      * Error encountered.
     C     ZAMSID        IFNE      'BRG0002'
     C     ZAMSID        ANDNE     'BRG0001'
     C                   MOVE      '1'           *IN50
     C                   ENDIF
      *
     C     SendMsgE      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial subroutine.                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Initialise program name.
     C                   MOVEL     'UP009001'    WPGM
      *
      * Set up subfile message queue information.
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      '1'           *IN40
      *
      * Key lists
     C     UPAFFDK       KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFFDPS
      *
     C     INZSRE        ENDSR
      *
      /EJECT
      ********************************************************************
     C     *PSSR         BEGSR
      *
     C     Recursive     IFEQ      *BLANKS
      *
     C                   MOVE      'Y'           Recursive
      *
     C                   MOVEL     '*ERROR'      ReturnCode
      *
     C                   DUMP
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
      *
     C     PSSRE         ENDSR
      *****************************************************************
