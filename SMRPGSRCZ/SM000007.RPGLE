     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*XBI *  OVRDBF FILE(TBLTXT) TOFILE(SMTBLXPD)                         *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update trailers from "from" release')         *
/*E*I****DBGVIEW(*LIST)************************************************                    AR1089839
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000007 - Update trailers from 'from' release               *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. MD055914           Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD025682           Date 19Aug14               *
      *                 MD020569           Date 28May13               *
      *                  AR1089839             Date 19Feb13           *
      *                  AR988376B             Date 12Feb13           *
      *                  AR988376A             Date 12Feb13           *
      *                  CUP003                Date 04Nov10           *
      *                  BUG27792  *CREATE     Date 02Jun10           *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055914 - Incorrect TRLR menu processing in Bridge for      *
      *             SDCUSTPD. Replaced DOU condition with DOW NOT.    *
      *  MD046248 - Finastra Rebranding                               *
      *  MD025682 - Correct SDCMRKPD trailer failure in COB.          *
      *  MD020569 - SDC0602 seq 00001 has failed during COB run       *
      *  AR1089839 - COBOP and 2.1 source clashes                     *
      *  AR988376B - SDC0602 failed during cob run (Child:AR988377)   *
      *  AR988376A - Data migration of SDFCTLPA (Child:AR988377)      *
      *  CUP003 - Does not handle the alpha-keys on TABLETX.          *
      *  BUG27792 - Postings reconciliation utility                   *
      *                                                               *
      *****************************************************************
      *
     FSDFCTLPA  UF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
     FSMFCTLPA  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFCTLA0:FCTLF)
     F                                     USROPN
     F*TABLETX**UF   E             DISK    INFSR(*PSSR)                                       CUP003
     FTBLTXT    UF   E           K DISK    INFSR(*PSSR)                                       CUP003
     FSDCUSTL8  IF   E           K DISK    INFSR(*PSSR)                                    AR988376B
     FSMTBLXPD  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(TABLETXF:TBLXF)
     F                                     PREFIX(F)
     FSDCMRKPD  IF   E             DISK    INFSR(*PSSR)                                     MD025682
      *
     D SDFCTLExist     S              1
     D RETRRecs        S              4  0
     D NARRRecs        S              4  0
     D BROKRecs        S              4  0
     D Recursive       S              1    INZ(' ')
     D Readnext        S              1A                                                   AR988376A
     D Wnotfnd         S              1A                                                   AR988376A
     D WFLD            S              5P 0                                                 AR988376B
      *
      * User space data structure
     D Input           DS
     D  Format                 1      8    INZ('MBRD0200')
     D  MemberName             9     18    INZ('*FIRST')
     D  FileName              19     38
     D  File                  19     28
     D  FileLibrary           29     38    INZ('*LIBL')
     D  OverrideProc          39     39    INZ('0')
     D  ErrorData             40     43B 0 INZ(0)
     D  MemberDataLen         44     47B 0 INZ(144)
      *
      * Data structure for file data.
     D MemberData      DS
     D  NoOfRecs             141    144B 0
      *
     C     *ENTRY        PLIST
     C                   PARM                    SDFCTLExist
      *
      * Read TABLETX and then check the 'to' system to see if a record for
      *  this exists there.  If it does update it.
     C*****1****         SETLL     TABLETX                                                    CUP003
     C**********         READ      TABLETX                                                    CUP003
     C                   EVAL      Readnext = 'N'                                          AR988376A
     C                   EVAL      Wnotfnd = 'N'                                           AR988376A
     C     *LOVAL        SETLL     TBLTXT                                                     CUP003
     C                   READ      TBLTXT                                                     CUP003
      *
     C                   DOU       %EOF
     C     RECT          CHAIN     TBLXF
     C                   IF        %FOUND
     C                   EXSR      UpdateFields
      * Exception processing for SDRETRPD ...
     C**********         IF        RECT = 41                                                  CUP003
     C                   IF        RECT = '41'                                                CUP003
     C                   EVAL      File = 'SDRETRPD'
     C                   EXSR      GetNoOfRecs
     C                   EVAL      NREC = NoOfRecs
     C                   EVAL      RETRRecs = NoOfRecs
     C                   ENDIF
      * ... and SDNARRPD.
     C**********         IF        RECT = 90                                                  CUP003
     C                   IF        RECT = '90'                                                CUP003
     C                   EVAL      File = 'SDNARRPD'
     C                   EXSR      GetNoOfRecs
     C                   EVAL      NREC = NoOfRecs
     C                   EVAL      NarrRecs = NoOfRecs
     C                   ENDIF
     C                   UPDATE    TABLETXF
     C                   ENDIF
     C**********         READ      TABLETX                                                    CUP003
     C                   READ      TBLTXT                                                     CUP003
     C                   ENDDO
      *
      * Get number of records for SDBROKPD.
     C                   EVAL      File = 'SDBROKPD'
     C                   EXSR      GetNoOfRecs
     C                   EVAL      BROKRecs = NoOfRecs
      *
     C                   IF        SDFCTLExist = 'Y'
     C                   OPEN      SDFCTLPA
     C                   OPEN      SMFCTLPA
      * Read SDFCTLPA and then check the 'to' system to see if a record for
      *  this exists there.  If it does update it.
     C     1             SETLL     SDFCTLPA
     C                   READ      SDFCTLPA
      *
     C                   DOU       %EOF
     C     AHFLNM        CHAIN     FCTLF
     C                   IF        %FOUND
     C                   IF        AHFLNM = 'SDRETRPD'
     C                   EVAL      AHNORC = RETRRecs
     C                   ENDIF
     C                   IF        AHFLNM = 'SDNARRPD'
     C                   EVAL      AHNORC = NARRRecs
     C                   ENDIF
     C                   IF        AHFLNM = 'SDBROKPD'
     C                   EVAL      AHNORC = BROKRecs
     C                   ENDIF
     C                   UPDATE    SDFCTLA0
     C                   ENDIF
     C                   READ      SDFCTLPA
     C                   ENDDO
      *
     C                   EVAL      Readnext = 'Y'                                          AR988376A
     C     1             SETLL     SDFCTLPA                                                AR988376A
     C                   READ      SDFCTLPA                                                AR988376A
      *                                                                                    AR988376A
     C                   DOU       %EOF(SDFCTLPA)                                          AR988376A
      *                                                                                    AR988376A
     C                   IF        AHFLNM <> 'SDRETRPD' AND                                AR988376A
     C**********                   AHFLNM <> 'SDNARRPD' AND                      AR988376A AR988376B
     C**********                   AHFLNM <> 'SDBROKPD'                          AR988376A AR988376B
     C                             AHFLNM <> 'SDNARRPD'                                    AR988376B
     C                   EVAL      File = AHFLNM                                           AR988376A
     C                   EXSR      GetNoOfRecs                                             AR988376A
     C     READNXT       TAG                                                               AR988376A
     C                   IF        Wnotfnd = 'Y'                                           AR988376A
     C                   EVAL      AHNORC = 0                                              AR988376A
     C                   EVAL      Wnotfnd = 'N'                                           AR988376A
     C                   ELSE                                                              AR988376A
     C**********         EVAL      AHNORC = NoOfRecs                              AR988376A MD020569
     C                   MOVE      NoOfRecs      WNoRecs           5 0                      MD020569
     C                   EVAL      AHNORC = WNoRecs                                         MD020569
     C                   ENDIF                                                             AR988376A
      *                                                                                    AR988376A
     C                   IF        AHFLNM = 'SDBROKPD' AND                                 AR988376B
     C                             AHNORC <> 0                                             AR988376B
     C                   EVAL      AHNORC = AHNORC - 4                                     AR988376B
     C                   ENDIF                                                             AR988376B
      *                                                                                    AR988376B
     C                   IF        AHFLNM = 'SDCUSTPD' AND                                 AR988376B
     C                             AHNORC <> 0                                             AR988376B
     C                   EVAL      WFLD = 0                                                AR988376B
     C     *LOVAL        SETLL     SDCUSTL8                                                AR988376B
     C                   READ      SDCUSTL8                                                AR988376B
      *                                                                                    AR988376B
     C**********         DOU       %EOF(SDCUSTL8)                                 AR988376B MD055914
     C                   DOW       NOT %EOF(SDCUSTL8)                                       MD055914
     C                   EVAL      WFLD = WFLD + 1                                         AR988376B
     C                   READ      SDCUSTL8                                                AR988376B
     C                   ENDDO                                                             AR988376B
      *                                                                                    AR988376B
     C                   EVAL      AHNORC = AHNORC - WFLD                                  AR988376B
     C                   ENDIF                                                             AR988376B
      *                                                                                    AR988376B
     C                   IF        AHFLNM = 'SDCMRKPD' AND                                  MD025682
     C                             AHNORC <> 0                                              MD025682
     C                   EVAL      WFLD = 0                                                 MD025682
     C     1             SETLL     SDCMRKPD                                                 MD025682
     C                   READ      SDCMRKPD                                                 MD025682
      *                                                                                     MD025682
     C                   DOU       %EOF(SDCMRKPD)                                           MD025682
     C                   IF        D7TYLC = 'D'                                             MD025682
     C                   EVAL      WFLD = WFLD + 1                                          MD025682
     C                   ENDIF                                                              MD025682
     C                   READ      SDCMRKPD                                                 MD025682
     C                   ENDDO                                                              MD025682
      *                                                                                     MD025682
     C                   EVAL      AHNORC = AHNORC - WFLD                                   MD025682
     C                   ENDIF                                                              MD025682
      *                                                                                     MD025682
     C                   UPDATE    SDFCTLA0                                                AR988376A
     C                   ENDIF                                                             AR988376A
      *                                                                                    AR988376A
     C                   READ      SDFCTLPA                                                AR988376A
     C                   ENDDO                                                             AR988376A
      *                                                                                    AR988376A
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      *  GetNoOfRecs - Find number of records on file.                *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     GetNoOfRecs   BEGSR
      *
      * Generate file details list.
     C                   CALL      'QUSRMBRD'
     C                   PARM                    MemberData
     C                   PARM                    MemberDataLen
     C                   PARM      'MBRD0200'    Format
     C                   PARM                    FileName
     C                   PARM      '*FIRST'      MemberName
     C                   PARM      '0'           OverrideProc
     C                   PARM                    ErrorData
     C     GetNoOfRecsE  ENDSR
      *
      *****************************************************************
      *                                                               *
      *  UpdateFields - Update fields on TABLETX.                     *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     UpdateFields  BEGSR
      *
     C                   EVAL      ZZ010  = FZZ010
     C                   EVAL      NREC   = FNREC
     C                   EVAL      NINS   = FNINS
     C                   EVAL      NDEL   = FNDEL
     C                   EVAL      NAMD   = FNAMD
     C                   EVAL      LRNO   = FLRNO
     C                   EVAL      ZZ058  = FZZ058
     C                   EVAL      LCD    = 0
     C                   EVAL      CHTP   = ' '
     C                   EVAL      TNLU   = FTNLU
      *
     C     UpdateFieldsE ENDSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Readnext = 'Y'                                          AR988376A
     C                   EVAL      Wnotfnd = 'Y'                                           AR988376A
     C                   GOTO      READNXT                                                 AR988376A
     C                   ENDIF                                                             AR988376A
     C                   SETON                                        U7U8LR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C     EPSSR         ENDSR
      *
      *****************************************************************
