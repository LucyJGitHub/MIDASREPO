     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Error Messages in Sections Report')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge Module                                        *
      *                                                               *
      *  UP008020 - Error Messages in Sections Report                 *
      *                                                               *
      *  Function: This program will output records to files UPSHDRPD *
      *            or UPSERRPD when the passed in modes are *WRTHDR or*
      *            *WRTDTL respectively.  It will generate report     *
      *            UP008020P1 when passed in mode is *REPORT.         *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256038  *CREATE    Date 24Feb05               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  256038 - Reporting of error messages in sections.            *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *                                                               *
      *       20      End of file  (UPSERRPD)                         *
      *       32      Chain - record not found  or EOF (UPSHDRPD)     *
      *       37      Report overflow indicator                       *
      *       39      Page header needed                              *
      *                                                               *
      *****************************************************************
     FUPSHDRPD  IF A E           K DISK    INFSR(*PSSR)
      *  RTV/WRT: Error Report Section Details File
      *
     FUPSERRPD  IF A E           K DISK    INFSR(*PSSR)
      *  RTV/WRT: Error Details File
      *
     FUP008020P1O    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN37)
     F                                     USROPN
      *  WRT: Error Messages in Sections Report
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      * Data structure for Section Headers file
     D                 DS
     D  SHID
     D  SHSEQ
     D  SHDSPos
     D  SHHdr
     DSectHeader               1    116A
      *
      * Data structure for Error Messages file
     D                 DS
     D  SEID
     D  SEKFLD
     D  SEMDTL
     DErrorMsg                 1    197
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D PrevSectID      S                   LIKE(SEID)                           Previous Section Id
     D K_SHId          S                   LIKE(SHID)                           Key fld to UPSHDRPD
     D K_SHSeq         S                   LIKE(SHSEQ)                          Key fld to UPSHDRPD
      *
      /EJECT
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    Mode              7
     C                   PARM                    PassedInDtl     197
      *
     C     SHdrKLst      KLIST
     C                   KFLD                    K_SHId                         Section Id
     C                   KFLD                    K_SHSeq                        Section Hdr Seq
      *
      * *Write Header mode
     C                   IF        Mode = '*WRTHDR'
      *
     C                   EVAL      SectHeader =  PassedInDtl
     C                   WRITE     UPSHDRD0
     C                   ENDIF
      *
      * *Write Message mode
     C                   IF        Mode = '*WRTDTL'
     C                   EVAL      ErrorMsg   =  PassedInDtl
     C                   WRITE     UPSERRD0
     C                   ENDIF
      *
      * *REPORT mode
     C     Mode          IFEQ      '*REPORT'
      *
     C                   OPEN      UP008020P1
     C                   EVAL      #TITLE   = PassedInDtl
     C                   WRITE     HEAD
     C                   SETOFF                                       39
      *
     C     *LOVAL        SETLL     UPSERRPD
      *
     C                   READ      UPSERRPD                               20
      *
      * If there are no records at all write 'no records'.
     C                   IF        *IN20 = *ON
     C                   WRITE     NORECS
     C                   GOTO      ENDPGM
     C                   ENDIF                                                  FI *IN20 = *ON
      *
     C                   EVAL      PrevSectId  = *BLANK
      *
     C                   DOW       *IN20 = *OFF
      *
     C                   IF        PrevSectId  <> SEID OR                       New section id OR
     C                             (PrevSectId  =  SEID AND                     have overflow for
     C                              *IN39 = *OFF)                               same section id
      *
      * Print section header text and column heading according to section id.
     C                   EXSR      PrtSTxtNColH
      *
     C                   EVAL      PrevSectId  = SEID
     C                   ENDIF                                                  FI PrevSectId <>SEID
      *
     C                   EVAL      @ErrMsg = SEKFLD
     C                   EVAL      %SUBST(@ErrMsg:SHdSPos) = SEMDTL
      *
     C                   WRITE     ERRDTL
     C                   SETON                                        39
      *
      * If overflow on, then write header
     C                   IF        *IN37 = *ON                                  Overflow
     C                   WRITE     HEAD
     C                   SETOFF                                       3739
     C                   ENDIF                                                  FI *IN37 = *OFF
      *
     C                   READ      UPSERRPD                               20
     C                   ENDDO                                                  ODW *IN20 = *OFF
      *
     C     ENDPGM        TAG
     C                   WRITE     TRAILP
     C                   CLOSE     UP008020P1
      *
     C                   ENDIF                                                  FI mode = *REPORT
      *
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * PrtSTxtNColH   - Print section text and column header(s)      *
      *                  according to section id SEID                 *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     PrtSTxtNColH  BEGSR                                                  ** SetSectText **
      *
      * Get section header rec from file UPSHDRPD.
     C                   EVAL      K_SHId    = SEID
     C                   EVAL      K_SHSeq   = 1                                for section hdr text
      *
     C     SHdrKLst      CHAIN     UPSHDRPD                           32        Rec not found
     C   32              EXSR      *PSSR
      *
      * If Page header has not been printed, print Page Header.
     C   39              WRITE     HEAD
      *
      * Output section header texts until no more column lines for the section id.
     C                   DOW       *IN32 = *OFF  AND
     C                             SHID  = SEID
      *
     C                   EVAL      @SECTTXT  = SHHDR
     C                   WRITE     SECTHDR
      *
     C                   READ      UPSHDRPD                               32    EOF
     C                   ENDDO                                                  ODW *IN32 = *OFF
      *                                                                          and SHID  = SEID
      * Get Column header(s) until no more column lines for the section id.
     C                   EVAL      K_SHId    = %SUBST(SEID:1:2) + 'COL'
     C                   EVAL      K_SHSeq   = 1
      *
     C     SHdrKLst      CHAIN     UPSHDRPD                           32        Rec not found
      *
     C                   DOW       *IN32 = *OFF  AND
     C                             SHID  = K_SHId
      *
      * Output column header line
     C                   EVAL      @COLHDR   = SHHDR
     C                   WRITE     COLHDR
      *
     C                   READ      UPSHDRPD                               32    EOF
     C                   ENDDO                                                  ODW *IN30 = *OFF
      *                                                                          and SHID  = SEID
      *
     C     PrtSTxtNColHE ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
