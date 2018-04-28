     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*XBI *  CRTPF FILE(QTEMP/UPERRMQT) RCDLEN(100)                       *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Populate driving file from dlv. data')        *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000094 - Populate driving file from delivered data         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. Ar850292 *RENAMED  Date 17Oct11               *
      *  Prev Amend No. CUP021  *MOVED     Date 04Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK019  *CREATE    Date 09Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Ar850292  - Renamed from UP0094 to avoid zone/global clash.  *
      *  CUP021 - Rewrite of Action File processing                   *
      *         - Moved from zone                                     *
      *  CPK019 - Addition to CRTDLVLIST utility.                     *
      *                                                               *
      *****************************************************************
     F/EJECT
      *
     FUPACTFL0  IF   E           K DISK
     F*UPACTFL1*IF***E*          K DISK                                                       CUP021
     F*UPGPACTFL0IF**E*          K DISK                                                       CUP021
     F**********                           RENAME(UPACTFD0:UPGPACTF0)                         CUP021
     F*UPGPACTFL1IF**E*          K DISK                                                       CUP021
     F**********                           RENAME(UPCPYFD0:UPGPACTF1)                         CUP021
      *
     FUPDLVCL0  UF A E           K DISK
      *
     FUPAFCPPD  IF   E             DISK                                                       CUP021
      *
     FUPERRMQT  IF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(UPERRMQT:ERRM)
     F                                     PREFIX(X)
      *
     FUP0094P1  O    E             PRINTER OFLIND(*IN37)
     F                                     INFSR(*PSSR)
     F                                     USROPN
      *
      *****************************************************************
      *                                                               *
      *  Indicators                                                   *
      *                                                               *
      *    10 - End of file UP0094OF                                  *
      *                                                               *
      *****************************************************************
      /EJECT
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D Replace         C                   '*REPLACE'
     D Add             C                   '*ADD'
     D Delete          C                   '_X'
     D Space           C                   ' '
      *
     D Mode            S              7
     D Object          S             10
     D ObjectType      S             10
     D Text            S             50
     D ItemText        S             50
     D AmendOrNew      S              5
     D GlobOrZone      S              7
     D Member          S             10
     D Member_X        S             10
     D DeletePos       S              1  0
     D Type            S             10
     D ActionFile      S              7    INZ('N')
     D Module          S             10
     D SaveFile        S             10                                                       CUP021
     D MBTX            S                   LIKE(AUMBTX)                                       CUP021
     D CAPR            S                   LIKE(AUCAPR)                                       CUP021
     D IPTY            S                   LIKE(AUIPTY)                                       CUP021
     D DTYP            S                   LIKE(AUDTYP)                                       CUP021
     D DTLB            S                   LIKE(AUDTLB)                                       CUP021
     D CPYO            S                   LIKE(AUCPYO)                                       CUP021
      *
     D*ProblemText*    S             80    DIM(5) CTDATA PERRCD(1)                            CUP021
     D ProblemText     S             80    DIM(6) CTDATA PERRCD(1)                            CUP021
      *
     C/TITLE
      *
     C     *ENTRY        PLIST
     C                   PARM                    Mode
     C                   PARM                    Object
     C                   PARM                    ObjectType
     C                   PARM                    Text
     C                   PARM                    ItemText
     C                   PARM                    AmendOrNew
     C                   PARM                    GlobOrZone
      *
     C     MemberAndType KLIST
     C                   KFLD                    Member
     C                   KFLD                    Type
      *
     C                   IF        Mode = '*REPORT'
     C                   EXSR      WriteReportSR
     C                   ELSE
      *
      * Check for object type.
     C                   SELECT
      *
     C                   WHEN      ObjectType = '*MSGF'
     C                   EXSR      MessageFileSR
      *
     C                   WHEN      ObjectType = '*FILE'
     C                   EXSR      DataFileSR
      *
     C                   OTHER
     C                   EVAL      XUPERRMQT = Object
     C                   EVAL      XUPERRMQT = %TRIMR(XUPERRMQT) +
     C                             Space +
     C                             ProblemText(1)
     C                   WRITE     ERRM
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  MessageFileSR - Update driving file for message file         *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     MessageFileSR BEGSR
      *
      * Update fields on driving file.
     C                   EVAL      AUMBNM = Object
     C                   EVAL      AUMBTP = 'MSGF'
     C**********         EVAL      AUMBTX = ItemText                                          CUP021
     C**********         EVAL      AUIPTY = 9                                                 CUP021
     C**********         EVAL      AUDTYP = 'O'                                               CUP021
     C                   EVAL      MBTX = ItemText                                            CUP021
     C                   EVAL      IPTY = 9                                                   CUP021
     C                   EVAL      DTYP = 'O'                                                 CUP021
      *
      * Subroutine for AUCAPR
     C                   EXSR      AmendOrNewSR
      *
      * Subroutine for AUDTLB
     C                   EXSR      GlobOrZoneSR
      *
      * Check whether record already exists on driving file.
     C                   Eval      Member = Object
     C                   Eval      Type   = 'MSGF'
      *
      * Chain to UPDLVCL0 and write or update accordingly.
     C                   EXSR      ChainSR
      *
     C     EMessageFileSRENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  DataFileSR - Update driving file for data file               *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     DataFileSR    BEGSR
      *
      * If file is UPAFCPPD then perform one-off subroutine.                                  CUP021
     C                   IF        Object = 'UPAFCPPD'                                        CUP021
     C                   EXSR      WriteAF                                                    CUP021
     C                   ELSE                                                                 CUP021
      **Check*whether*file*is*actually*an*Action File.*                                       CUP021
     C                   EVAL      Member = Object
     C*****Member        CHAIN     UPACTFL1                                                   CUP021
     C**********         IF        NOT %FOUND                                                 CUP021
     C*****Member        CHAIN     UPGPACTFL1                                                 CUP021
     C**********         IF        NOT %FOUND                                                 CUP021
      * Check if file should have been delivered as an Action File.
     C                   EXSR      ChkActFileSR
     C**********         ELSE                                                                 CUP021
     C**********         EVAL      AUMBNM = AABONF                                            CUP021
     C**********         EVAL      Object = AABONF                                            CUP021
     C**********         EVAL      ActionFile = 'Y'                                           CUP021
     C**********         ENDIF                                                                CUP021
     C**********         ELSE
     C**********         EVAL      AUMBNM = AABONF
     C**********         EVAL      Object = AABONF
     C**********         EVAL      ActionFile = 'Y'
     C**********         ENDIF
     C
     C                   EVAL      AUMBTP = 'DATA'
     C**********         EVAL      AUMBTX = ItemText                                          CUP021
     C**********         EVAL      AUIPTY = 9                                                 CUP021
     C                   EVAL      MBTX = ItemText                                            CUP021
     C                   EVAL      IPTY = 9                                                   CUP021
     C                   IF        ActionFile = 'Y'
     C**********         EVAL      AUDTYP = 'I'                                               CUP021
     C                   EVAL      DTYP = 'I'                                                 CUP021
     C                   ELSE
     C**********         EVAL      AUDTYP = 'O'                                               CUP021
     C                   EVAL      DTYP = 'O'                                                 CUP021
      * If it is not an Action File then check text to see if file needs
      *  to be copied *REPLACE or *ADD.
     C                   EXSR      ReplaceOrAdd
     C                   ENDIF
      *
      * Subroutine for AUCAPR.
     C                   EXSR      AmendOrNewSR
      *
      * Subroutine for AUDTLB.
     C                   EXSR      GlobOrZoneSR
      *
      * Check whether record already exists on driving file.
     C                   Eval      Member = Object
     C                   Eval      Type   = 'DATA'
      *
      * Chain to UPDLVCL0 and write or update accordingly.
     C                   EXSR      ChainSR
      *
     C                   ENDIF                                                                CUP021
      *
     C     EDataFileSR   ENDSR
      *
      /EJECT                                                                                  CUP021
      *****************************************************************                       CUP021
      *                                                               *                       CUP021
      *  WriteAF - Write Action File data from UPAFCPPD               *                       CUP021
      *                                                               *                       CUP021
      *  Called By: DataFileSR                                        *                       CUP021
      *                                                               *                       CUP021
      *  Calls:                                                       *                       CUP021
      *                                                               *                       CUP021
      *****************************************************************                       CUP021
     C     WriteAF       BEGSR                                                                CUP021
      *
     C     1             SETLL     UPAFCPPD                                                   CUP021
     C                   READ      UPAFCPPD                                                   CUP021
     C                   DOW       NOT(%EOF)                                                  CUP021
      *
     C                   IF        ATFILE <> SaveFile                                         CUP021
     C                   EVAL      SaveFile = ATFILE                                          CUP021
     C                   EVAL      Member = ATFILE                                            CUP021
     C                   EVAL      AUMBNM = ATFILE                                            CUP021
     C                   EVAL      Type = 'DATA'                                              CUP021
     C                   EVAL      AUMBTP = 'DATA'                                            CUP021
     C                   EVAL      CAPR = 'A'                                                 CUP021
     C                   EVAL      IPTY = 9                                                   CUP021
     C                   EVAL      DTYP = 'I'                                                 CUP021
     C     ATFILE        CHAIN     UPACTFL0                                                   CUP021
     C                   IF        NOT(%FOUND)                                                CUP021
     C                   EVAL      XUPERRMQT = ATFILE                                         CUP021
     C                   EVAL      XUPERRMQT = %TRIMR(XUPERRMQT) +                            CUP021
     C                             Space +                                                    CUP021
     C                             ProblemText(6)                                             CUP021
     C                   WRITE     ERRM                                                       CUP021
     C                   ELSE                                                                 CUP021
     C                   EVAL      DTLB = AALAYR                                              CUP021
     C                   ENDIF                                                                CUP021
      *
      * Chain to UPDLVCL0 and write or update accordingly.                                    CUP021
     C                   EXSR      ChainSR                                                    CUP021
      *
     C                   ENDIF                                                                CUP021
      *
     C                   READ      UPAFCPPD                                                   CUP021
     C                   ENDDO                                                                CUP021
      *
     C     EWriteAF      ENDSR                                                                CUP021
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  AmendOrNewSR - Update AUCAPR                                 *
      *                                                               *
      *  Called By: MessageFileSR                                     *
      *             DataFileSR                                        *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     AmendOrNewSR  BEGSR
      *
     C                   IF        AmendOrNew = 'AMEND'
     C**********         EVAL      AUCAPR = 'A'                                               CUP021
     C                   EVAL      CAPR = 'A'                                                 CUP021
     C                   ELSE
     C**********         EVAL      AUCAPR = 'N'                                               CUP021
     C                   EVAL      CAPR = 'N'                                                 CUP021
     C                   ENDIF
      *
     C     EAmendOrNewSR ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  GlobOrZoneSR - Update AUDTLB                                 *
      *                                                               *
      *  Called By: MessageFileSR                                     *
      *             DataFileSR                                        *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     GlobOrZoneSR  BEGSR
      *
     C                   SELECT
      *
     C                   WHEN      GlobOrZone = 'GLOBAL'
     C**********         EVAL      AUDTLB = '*GLOBAL'                                         CUP021
     C                   EVAL      DTLB = '*GLOBAL'                                           CUP021
      *
     C                   WHEN      GlobOrZone = 'ZONE'
     C**********         EVAL      AUDTLB = '*ZONE'                                           CUP021
     C                   EVAL      DTLB = '*ZONE'                                             CUP021
      *
     C                   OTHER
     C                   EVAL      XUPERRMQT = ProblemText(2)
     C                   EVAL      XUPERRMQT = %TRIMR(XUPERRMQT) +
     C                             Space +
     C                             Object
     C                   EVAL      XUPERRMQT = %TRIMR(XUPERRMQT) +
     C                             Space +
     C                             ObjectType
     C                   EVAL      XUPERRMQT = %TRIMR(XUPERRMQT) +
     C                             Space +
     C                             ProblemText(3)
     C                   WRITE     ERRM
      *
     C                   ENDSL
      *
     C     EGlobOrZoneSR ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ReplaceOrAdd - Attempt to find out how file should be copied *
      *                                                               *
      *  Called By: DataFileSR                                        *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     ReplaceOrAdd  BEGSR
      *
      * If the object text does not contain '*REPLACE'or ...
     C                   IF        %SCAN(Replace:Text) = 0
      * ... or '*ADD'...
     C                   IF        %SCAN(Add:Text) = 0
      * ... then write problem record.
     C                   EVAL      XUPERRMQT = ProblemText(2)
     C                   EVAL      XUPERRMQT = %TRIMR(XUPERRMQT) +
     C                             Space +
     C                             Object
     C                   EVAL      XUPERRMQT = %TRIMR(XUPERRMQT) +
     C                             Space +
     C                             ObjectType
     C                   EVAL      XUPERRMQT = %TRIMR(XUPERRMQT) +
     C                             Space +
     C                             ProblemText(4)
     C                   WRITE     ERRM
      *
      * If '*ADD' is found update the Copy Option ...
     C                   ELSE
     C**********         EVAL      AUCPYO = '*ADD'                                            CUP021
     C                   EVAL      CPYO = '*ADD'                                              CUP021
     C                   ENDIF
      * ... or '*REPLACE'.
     C                   ELSE
     C**********         EVAL      AUCPYO = '*REPLACE'                                        CUP021
     C                   EVAL      CPYO = '*REPLACE'                                          CUP021
     C                   ENDIF
      *
     C     EReplaceOrAdd ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ChkActFileSR - Check if file has Action File                 *
      *                                                               *
      *  Called By: DataFileSR                                        *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     ChkActFileSR  BEGSR
      *
     C                   IF        Member <> 'UPGMULPD'                                       CUP021
      *
     C     Member        CHAIN     UPACTFL0
     C                   IF        NOT %FOUND
     C*****Member        CHAIN     UPGPACTFL0                                                 CUP021
     C**********         IF        NOT %FOUND                                                 CUP021
     C                   EVAL      AUMBNM = Object
     C**********         ENDIF                                                                CUP021
     C                   ENDIF
      *
     C                   IF        %FOUND
     C**********         IF        AAFRMF <> '*NONE'                                          CUP021
     C                   IF        AAAFLF <> '*NONE'                                          CUP021
     C                   EVAL      XUPERRMQT = Object
     C                   EVAL      XUPERRMQT = %TRIMR(XUPERRMQT) +
     C                             Space +
     C                             ProblemText(5)
     C                   EVAL      AUMBNM = AABONF
     C                   EVAL      ActionFile = 'Y'
     C                   WRITE     ERRM
     C                   ELSE
     C                   EVAL      AUMBNM = Object
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE                                                                 CUP021
     C                   EVAL      AUMBNM = 'T_GRMENUL'                                       CUP021
     C                   EVAL      ActionFile = 'Y'                                           CUP021
     C                   ENDIF                                                                CUP021
      *
     C     EChkActFileSR ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ChainSR - Chain to UPDLVC                                    *
      *                                                               *
      *  Called By: MessageFileSR                                     *
      *             DataFileSR                                        *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     ChainSR       BEGSR
      *
     C     MemberAndType CHAIN     UPDLVCL0
      *
     C                   EVAL      AUMBTX = MBTX                                              CUP021
     C                   EVAL      AUCAPR = CAPR                                              CUP021
     C                   EVAL      AUIPTY = IPTY                                              CUP021
     C                   EVAL      AUDTYP = DTYP                                              CUP021
     C                   EVAL      AUDTLB = DTLB                                              CUP021
     C                   EVAL      AUCPYO = CPYO                                              CUP021
      *
     C                   IF        NOT %FOUND
     C                   WRITE     @DLVCL0
     C                   ELSE
     C                   UPDATE    @DLVCL0
     C                   ENDIF
      *
     C     EChainSR      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  WriteReportSR - Produce printed report                       *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     WriteReportSR BEGSR
      *
     C     1             SETLL     UPERRMQT
     C                   READ      UPERRMQT
      * If there are no records then set return parameter ...
     C                   IF        %EOF
     C                   EVAL      Mode = '*NONE'
      * ... else produce report.
     C                   ELSE
      *
     C                   OPEN      UP0094P1
     C                   WRITE     HEADF
      *
     C                   DOW       NOT %EOF
      *
     C                   IF        *IN37 = *ON
     C                   WRITE     HEADF
     C                   EVAL      *IN37 = *OFF
     C                   ENDIF
      *
     C                   EVAL      #PROB = XUPERRMQT
     C                   WRITE     DETAILF
      *
     C                   READ      UPERRMQT
      *
     C                   ENDDO
      *
     C                   IF        *IN37 = *ON
     C                   WRITE     HEADF
     C                   EVAL      *IN37 = *OFF
     C                   ENDIF
     C                   WRITE     TRAILERF
     C                   CLOSE     UP0094P1
      *
     C                   EVAL      Module = 'UP0094'
     C                   CALL      'UPC0092'
     C                   PARM                    Module
      *
     C                   ENDIF
      *
     C     EWriteReportSRENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: *ALL                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
** ProblemText
has an incorrect object type; no record has been written.
Unable to determine whether
belongs in the global or zone layer.
should be copied *REPLACE or *ADD.
should have had an Action File delivered.
delivered in UPAFCPPD but does not have Action File.                                          CUP021
