     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*XBIA*  OVRDBF FILE(CFFLL02) TOFILE(UPCFFLL0) SHARE(*NO)             *
/*XBIB*  OVRDBF FILE(CFFDL03) TOFILE(UPCFFDL0) SHARE(*NO)             *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Compare files details - maintenance')         *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP009002 - Compare files details - maintenance               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CUP040             Date 14Mar14               *
      *  Prev Amend No. CUP021  *CREATE    Date 18Jan11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP040 - New deliverable data methodology. Recompile.        *
      *  CUP021 - Rewrite of Action File processing                   *
      *                                                               *
      *****************************************************************
      *
     FUP009002DFCF   E             WORKSTN
     F                                     SFILE(UP009002F0:SflRrn)
     FUPCFFLL0  IF   E           K DISK
     FUPACTFL0  IF   E           K DISK
     FCFFLL02   UF A E           K DISK
     F                                     RENAME(UPCFFLD0:UPCFFLUPD)
     F                                     PREFIX(P_)
     FUPCFFDL0  IF   E           K DISK
     FCFFDL03   UF   E           K DISK
     F                                     RENAME(UPAFFDD0:DLTFFDFD0)
     D UPFLTD        E DS                  EXTNAME(UPCFFLPD)
     D P_UPFLTD      E DS                  EXTNAME(UPCFFLPD)
     D                                     PREFIX(P_)
     D UPFFDF        E DS                  EXTNAME(UPCFFDPD)
      *
     D                 DS
     D DDATR1                  1     11
     D DDLEN                   1      3
     D DDTYP                   4      4
     D DDOPNB                  6      6
     D DDDIG                   7      8
     D DDCOMA                  9      9
     D DDDEC                  10     10
     D DDCLOB                 11     11
      *
     D CheckFile       S              1    DIM(47) CTDATA PERRCD(47)
      *
     D ReturnCode      S              7
     D ErrorMsg        S             30
     D WReturnCode     S              7
     D WErrorMsg       S             30
     D Recursive       S              1
     D WINKC           S              1
     D WINKL           S              1
     D SourceLib       S             10
     D TargetLib       S             10
     D HEAD1           S             78
     D HEAD2           S             78
     D NumPerPag       S              2  0
     D ZAPGMQ          S             10
     D ZAPGRL          S              5
     D ZAMSID          S              7
     D ZAMSGF          S             10    INZ('UTMSGF')
     D ZAMSDA          S            132
     D ZAMSTP          S              7
     D ZFIELD          S             16
     D ZADEC           S              1  0
     D SflRrn          S              4  0
     D ToPIBO          S              5  0
     D URecN           S              2  0
     D UKYAR           S             60
     D UReturnCode     S              7
     D URecL           S              5  0
     D UDesc           S             50
     D UFile           S             10
     D ULib            S             10
     D CmdLen          S             15  5
      *
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    ErrorMsg
     C                   PARM                    UPFLTD
     C                   PARM                    SourceLib
     C                   PARM                    TargetLib
     C                   PARM                    WINKC
     C                   PARM                    WINKL
      *
      * Get file details.
     C                   EXSR      GetExpFmt
      *
      * Display subfile screen until F3, F6, F10 or F12 taken.
     C     *INKC         DOWEQ     '0'
     C     *INKF         ANDEQ     '0'
     C     *INKJ         ANDEQ     '0'
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
      * Fill current subfile page.
     C     *IN05         IFEQ      '1'
     C     *IN06         OREQ      '1'
     C     SflRrn        OREQ      *ZERO
     C  N50              EXSR      FillSubfile
     C                   ENDIF
      *
      * Write subfile control and footer.
     C                   IF        *IN08 = '0'
     C                   EVAL      DDHEAD = HEAD1
     C                   ELSE
     C                   EVAL      DDHEAD = HEAD2
     C                   ENDIF
      *
     C                   TIME                    DDTIME
     C                   WRITE     UP009002C2
     C                   WRITE     UP009002F1
      *
      * Read subfile control.
     C                   WRITE     UP009002C0
     C                   READ      UP009002C0                             99
      *
      * Clear the message queue and initial error indicators.
     C                   EXSR      ClearMsgQ
      *
      * If F3 and F12 were not taken.
     C     *INKC         IFEQ      '0'
     C     *INKL         ANDEQ     '0'
      *
      * Rolldown requested.
     C     *IN05         CASEQ     '1'           ROLLDOWN
      *
      * Delete the primary record.
     C     *INKJ         CASEQ     '1'           DelPrimRec
      *
      * Validate the screen
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
      * Clear the message queue & init error indicators.              *
      *                                                               *
      *****************************************************************
     C     ClearMsgQ     BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
      *
     C                   MOVEA     '0'           *IN(50)
     C                   MOVEA     '0000000000'  *IN(10)
     C                   MOVEA     '0000000000'  *IN(20)
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
      *  Validate File
     C     FLNAME        IFEQ      *BLANK
     C                   MOVEL     'BRG0006'     ZAMSID
     C                   EXSR      SendMsg
     C                   MOVE      '1'           *IN10
     C                   ELSE
     C                   MOVEA     FLNAME        CheckFile(12)
     C                   Z-ADD     47            CmdLen
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    CheckFile
     C                   PARM                    CmdLen
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'BRG0006'     ZAMSID
     C                   EXSR      SendMsg
     C                   MOVE      '1'           *IN10
     C                   ENDIF
     C                   ENDIF
      *
      * If add required, check that record does not already exist.
     C     *IN60         IFEQ      '1'
     C                   MOVEL     UPFLTD        P_UPFLTD
     C     UPFLTDK       CHAIN     UPCFFLD0                           99
     C     *IN99         IFEQ      '0'
     C                   MOVEL     P_UPFLTD      UPFLTD
     C                   MOVEL     'BRG0007'     ZAMSID
     C                   EXSR      SendMsg
     C                   MOVE      '1'           *IN10
     C                   ENDIF
     C                   ENDIF
      *
      * Get file description.
     C                   IF        FLFTXT = *blanks AND *IN10 = '0'
     C                   CALL      'UTAORCDF'
     C                   PARM      *blanks       UReturnCode
     C                   PARM      0             URecL
     C                   PARM      *blanks       UDesc
     C                   PARM      FLNAME        UFile
     C                   PARM      '*LIBL'       ULib
      *
     C                   IF        UDesc = *blanks
     C                   EVAL      FLFTXT = 'XXXXXXXXXXX'
     C                   ELSE
     C                   EVAL      FLFTXT = UDesc
     C                   ENDIF
     C                   ENDIF
      *
      * Validate keyed file if entered.
     C     FLKYLF        IFEQ      *BLANK
      * If no keyed field entered see if a file can be found on UPACTFPD.
     C     FLNAME        CHAIN     UPACTFL0
     C                   IF        %FOUND
     C                   EVAL      FLKYLF = AAAFLF
     C                   ENDIF
     C                   ENDIF
     C     FLKYLF        IFNE      *BLANK
     C                   MOVEA     '          '  CheckFile(12)
     C                   MOVEA     FLKYLF        CheckFile(12)
     C                   CALL      'UTAOKEYD'
     C                   PARM      *blanks       UReturnCode
     C                   PARM      0             URecN
     C                   PARM      *blanks       UKYAR
     C                   PARM      FLKYLF        UFile
     C                   PARM      '*LIBL'       ULib
      *
     C                   IF        UReturnCode  <> *BLANKS
     C                             or URecN = 0
     C                   MOVEL     'BRG0006'     ZAMSID
     C                   EXSR      SendMsg
     C                   MOVE      '1'           *IN11
     C                   ENDIF
     C                   ENDIF
      *
      * Validate file.
     C     FLREFF        IFEQ      *BLANK
     C                   MOVEL     'BRG0006'     ZAMSID
     C                   EXSR      SendMsg
     C                   MOVE      '1'           *IN14
     C                   ELSE
     C                   MOVEA     '          '  CheckFile(12)
     C                   MOVEA     FLREFF        CheckFile(12)
     C                   Z-ADD     47            CmdLen
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    CheckFile
     C                   PARM                    CmdLen
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'BRG0006'     ZAMSID
     C                   EXSR      SendMsg
     C                   MOVE      '1'           *IN14
     C                   ENDIF
     C                   ENDIF
      *
      *  Validate 'Create Fields'.
     C     DDCRFD        IFNE      'Y'
     C     DDCRFD        ANDNE     'N'
     C                   MOVEL     'BRG0008'     ZAMSID
     C                   EXSR      SendMsg
     C                   MOVE      '1'           *IN27
     C                   ENDIF
      *
      * If any fields are in error.  Disable F6 (if it was taken).
     C     *IN50         IFEQ      '1'
     C                   MOVE      '0'           *INKF
     C                   ELSE
      *
      * Update the primary record.
     C     *INKF         CASEQ     '1'           UpdPrimRec
      *
      * Toggle Display
     C     *INKH         CASEQ     '1'           ToggleDisp
      *
      * Check for a record selected from the subfile.
     C     *IN(04)       CASEQ     '0'           CheckSubfile
     C                   ENDCS
      *
     C                   ENDIF
      *
     C     ValScreenE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Update the primary record.                                    *
      *                                                               *
      *****************************************************************
     C     UpdPrimRec    BEGSR
      *
     C     UPFLTDK       CHAIN     UPCFFLUPD                          99
     C                   MOVEL     UPFLTD        P_UPFLTD
     C                   MOVE      DPOFFS        P_FLOFFS
     C                   EVAL      P_FLFCMP = DPCMP
     C     *IN99         IFEQ      '1'
     C                   WRITE     UPCFFLUPD
     C                   ELSE
     C                   UPDATE    UPCFFLUPD
     C                   ENDIF
      *
      * If 'create fields' requested.
     C     DDCRFD        IFEQ      'Y'
      *
      * Lock record.
     C     UPFLTDK       CHAIN     UPCFFLUPD                          98
      *
      * Do DSPFFD of file fields.
     C                   CALL      'UP009004'
     C                   PARM                    FLNAME
     C                   PARM                    UKYAR
     C                   PARM      *BLANKS       FLIB             10
      *
      * Release record.
     C  N98              UPDATE    UPCFFLUPD
      *
     C                   EVAL      DDCRFD = 'N'
      *
     C                   ENDIF
      *
     C                   EVAL      *IN06 = '0'
     C                   EVAL      *INKF = '0'
     C                   EVAL      *IN60 = '0'
      *
     C     UpdPrimRecE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Delete the primary record.                                    *
      *                                                               *
      *****************************************************************
     C     DelPrimRec    BEGSR
      *
     C     UPFLTDK       CHAIN     UPCFFLUPD                          99
     C     *IN99         IFEQ      '0'
     C                   DELETE    UPCFFLUPD
     C                   ENDIF
      *
      * Remove record in File Field Description File UPCFDFPD.
     C                   EVAL      AFFDPS = 0
     C     UPFFDFK       SETLL     DLTFFDFD0
     C                   EVAL      *IN99 = '0'
      *
      * If not end of file.
     C                   DOW       *IN99 = '0'
     C     UPFFDPK       READE     DLTFFDFD0                              99
     C                   IF        *IN99 = '0'
     C                   DELETE    DLTFFDFD0
     C                   ENDIF
     C                   ENDDO
      *
     C     DelPrimRecE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Check for a record selected from the subfile
      *                                                               *
      *****************************************************************
     C     CheckSubfile  BEGSR
      *
     C                   READC     UP009002F0                             99
      *
      * Do until all records processed.
     C     *IN99         DOWEQ     '0'
      *
      * If an action code is specified maintain the subfile record.
     C     DDACTN        IFNE      *BLANK
     C                   EXSR      MntSflRec
     C                   ELSE
     C                   MOVE      '0'           WINKC
     C                   ENDIF
      *
      * Return to top of subfile page.
     C                   Z-ADD     ToPIBO        AFFDPS
     C                   Z-ADD     *ZERO         SflRrn
      *
      * Read next if F3 not requested.
     C     WINKC         IFEQ      '0'
     C                   READC     UP009002F0                             99
     C                   ELSE
     C                   MOVE      '1'           *IN99
     C                   MOVE      WINKC         *INKC
     C                   END
      *
     C                   ENDDO
      *
     C     CheckSubfileE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Toggle name / text                                            *
      *                                                               *
      *****************************************************************
     C     ToggleDisp    BEGSR
      *
     C                   IF        *IN08 = '1'
     C                   EVAL      *IN08 = '0'
     C                   ELSE
     C                   EVAL      *IN08 = '1'
     C                   ENDIF
      * Return to top of subfile page.
     C                   Z-ADD     ToPIBO        AFFDPS
     C                   Z-ADD     *ZERO         SflRrn
      *
     C     ToggleDispE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Fill subfile                                                  *
      *                                                               *
      *****************************************************************
     C     FillSubfile   BEGSR
      *
     C                   MOVEA     '000'         *IN(1)
     C                   MOVEA     '1'           *IN(4)
     C                   Z-ADD     *ZERO         SflRrn
      *
      * Write subfile control*
     C                   WRITE     UP009002C0
      *
      * Get first record.
     C     UPFFDFK       SETLL     UPAFFDD0
     C     UPFFDPK       READE     UPAFFDD0                               99
      *
      * If not end of file.
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     AFFDPS        ToPIBO
     C                   ELSE
     C                   Z-ADD     *ZERO         ToPIBO
     C                   Z-ADD     *ZERO         AFFDPS
      *
      * Else, if end of file issue message.
     C                   MOVEL     'BRG0002'     ZAMSID
     C                   EXSR      SendMsg
     C                   ENDIF
      *
      * Do while not end of file.
     C     *IN99         DOWEQ     '0'
     C                   ADD       1             SflRrn                   04
      *
      * Format data for output.
     C                   EXSR      FormatData
      *
      * Write a record to the subfile.
     C                   WRITE     UP009002F0
     C     SflRrn        IFEQ      NumPerPag
     C     UPFFDPK       READE     UPAFFDD0                               99
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         AFFDPS
     C                   MOVEL     'BRG0002'     ZAMSID
     C                   EXSR      SendMsg
     C                   ELSE
     C                   SETON                                            99
     C                   END
     C                   ELSE
     C     UPFFDPK       READE     UPAFFDD0                               99
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         AFFDPS
     C                   MOVEL     'BRG0002'     ZAMSID
     C                   EXSR      SendMsg
     C                   END
     C                   END
      *
     C                   ENDDO
      *
      * Set on subfile control indicators.
     C     *IN(4)        IFEQ      '1'
     C                   MOVEA     '010'         *IN(1)
     C                   ELSE
     C                   MOVEA     '111'         *IN(1)
     C                   ENDIF
      *
     C     FillSubfileE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Maintain a record on the subfile                              *
      *                                                               *
      *****************************************************************
     C     MntSflRec     BEGSR
      *
      * If this is call from a toggle page then reset AFFDPS.
     C                   IF        *IN08 = '1'
     C                   EVAL      AFFDPS = DDFDPS
     C                   ENDIF
      *
     C                   CALL      'UP009001'
     C                   PARM      *BLANK        WReturnCode
     C                   PARM      *BLANK        WErrorMsg
     C                   PARM                    UPFFDF
     C                   PARM      '0'           WINKC
     C                   PARM      '0'           WINKL
      *
     C     WReturnCode   IFEQ      '*ERROR'
     C                   EVAL      ErrorMSg = 'Error in call to UP009001'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Return to top of subfile page.
     C                   Z-ADD     ToPIBO        AFFDPS
     C                   Z-ADD     *ZERO         SflRrn
      *
     C     MntSflRecE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Get Export Format Details                                     *
      *                                                               *
      *****************************************************************
     C     GetExpFmt     BEGSR
      *
     C     UPFLTDK       CHAIN     UPCFFLD0                           60
     C     *IN60         IFEQ      '1'
     C                   CLEAR                   UPFLTD
     C                   Z-ADD     0             FLOFFS
     C                   ENDIF
      *
      * Set up fields for display.
     C                   MOVE      FLOFFS        DPOFFS
     C                   EVAL      DPCMP = FLFCMP
      *
      * Initialise 'create fields' indicator.
     C     *IN60         IFEQ      '1'
     C                   MOVEL     'Y'           DDCRFD
     C                   ELSE
     C                   MOVEL     'N'           DDCRFD
     C                   ENDIF
      *
     C     GetExpFmtE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Format data for output                                        *
      *                                                               *
      *****************************************************************
     C     FormatData    BEGSR
      *
     C                   MOVE      '1'           *IN62
      *
      * Field.
     C                   MOVEL     AFFDNM        DDFLDI
      *
     C                   MOVEL     *BLANK        DDMFNM
     C                   MOVEL     AFFDTX        DDMFNM
      *
      * Field attributes.
     C                   MOVEL     *BLANK        DDATR1
      *
      * Set field length.
     C                   MOVEL     *BLANK        ZFIELD
     C     AFFDTP        IFEQ      'S'
     C     AFFDTP        OREQ      'P'
     C                   MOVE      AFFDND        ZFIELD
     C                   ELSE
     C                   MOVE      AFFDLN        ZFIELD
     C                   ENDIF
      *
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   MOVE      ZFIELD        DDLEN
      *
      * Set field type.
     C     AFFDTP        IFEQ      'S'
     C     AFFDTP        OREQ      'P'
     C                   MOVE      'N'           DDTYP
     C                   ELSE
     C                   MOVE      'A'           DDTYP
     C                   ENDIF
      *
      * Set field number of digits and decimal places.
     C     AFFDTP        IFEQ      'S'
     C     AFFDTP        OREQ      'P'
     C                   MOVEL     '('           DDOPNB
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      AFFDND        ZFIELD
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   MOVE      ZFIELD        DDDIG
     C                   MOVEL     ','           DDCOMA
     C                   MOVE      AFFDDP        DDDEC
     C                   MOVEL     ')'           DDCLOB
     C                   ENDIF
      *
     C                   EVAL      DDATR2 = DDATR1
     C                   EVAL      DDFDPS = AFFDPS
     C                   EVAL      DDKEYF = AFKEYF
     C                   EVAL      DDIGNC = AFIGNC
      *
     C     FormatDataE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Rolldown                                                      *
      *                                                               *
      ******************************************************************
     C     Rolldown      BEGSR
      *
     C                   Z-ADD     *ZERO         SflRrn
     C                   Z-ADD     ToPIBO        AFFDPS
      *
     C     UPFFDFK       SETGT     UPAFFDD0
     C     UPFFDPK       READPE    UPAFFDD0                               99
      *
      * Read previous until count matches count of records previous read.
     C     *IN99         DOWEQ     '0'
     C     SflRrn        ANDLT     NumPerPag
     C     UPFFDPK       READPE    UPAFFDD0                               99
     C                   ADD       1             SflRrn
     C                   ENDDO
      *
      * Issue start of file message.
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         AFFDPS
     C                   MOVEL     'BRG0001'     ZAMSID
     C                   EXSR      SendMsg
     C                   END
      *
     C     RolldownE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SendMsg - Send a message.                                     *
      *                                                               *
      *****************************************************************
     C     SendMsg       BEGSR
      *
     C                   CALL      'Y2SNMGC'                            0909
     C                   PARM      DDPGM         ZAPGMQ
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
     C                   MOVEL     'UP009002'    DDPGM            10
      *
      * Set up subfile message queue information.
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      '1'           *IN40
      *
     C                   Z-ADD     10            NumPerPag
     C                   EVAL      HEAD1 = 'X Field     '
     C                                   + 'Field Description       '
     C                                   + '                 '
     C                                   + 'Attributes  '
     C                                   + 'Pos.  '
     C                                   + 'Key '
     C                                   + 'Noc '
      *
     C                   EVAL      HEAD2 = 'X Field      '
     C                                   + 'Attributes  '
     C                                   + 'Pos.   '
     C                                   + 'Key '
     C                                   + 'Noc  ' + 'Diff  '
     C                                   + 'Nou'
      *
      * Initialise pointer.
     C                   Z-ADD     *ZERO         AFFDPS
      *
      * Key lists.
     C     UPFLTDK       KLIST
     C                   KFLD                    FLNAME
     C     UPFFDFK       KLIST
     C                   KFLD                    FLNAME
     C                   KFLD                    AFFDPS
      *
     C     UPFFDPK       KLIST
     C                   KFLD                    FLNAME
      *
     C     INZSRE        ENDSR
      *
      /EJECT
      ********************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     Recursive     IFEQ      *BLANKS
     C                   MOVE      'Y'           Recursive
     C                   MOVEL     '*ERROR'      ReturnCode
     C                   DUMP
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
      *
     C     PSSRE         ENDSR
      *****************************************************************
** CheckFile
CHKOBJ OBJ(          ) OBJTYPE(*FILE) AUT(*USE)
