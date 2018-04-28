     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ER Account Codes Decision Take-On')              *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000171 - Midas ER Account Codes Decision Take-On           *
      *                                                               *
      *  Function:  This program populates Account Codes Decision     *
      *             table with accounts from Account Codes file       *
      *             excluding titles.                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG26779           Date 27Nov09               *
      *                 CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26779 - Change Request on GSART Table                     *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    LR - Last record indicator (program termination)           *
      *    U7 and U8 - DB error processing indicator                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR    - Initialise                                       *
      *  *PSSR     - Error processing                                 *
      *                                                               *
      *****************************************************************
 
      ** Midas SD Account codes
 
     FSDACODPD  IF   E             DISK    INFSR(*PSSR)
 
      ** Midas ER Account Code Decision Table
 
     FERDEACL0  UF A E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
 
     D PRtCd           S              7A
     D POptn           S              7A
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * MAIN PROCEDURE                                                *
      *                                                               *
      *****************************************************************
 
      ** Read Account Codes
 
     C                   READ      SDACODPD
     C                   DOW       NOT %EOF(SDACODPD)
 
     C                   IF        A5TOIN = 'N'
 
     C     A5ACCD        SETLL     ERDEACL0
     C                   IF        NOT %EQUAL()
     C                   EVAL      N3ACOD = A5ACCD
     C                   EVAL      N3GRI  = ' '
     C                   EVAL      N3BUCL = '  '
     C                   EVAL      N3BUSU = 00
     C                   EVAL      N3BUTY = *BLANKS                                         BUG26779
     C                   EVAL      N3LCD  = BJRDNB
     C                   EVAL      N3TYLC = 'I'
     C                   WRITE     ERDEACD0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      SDACODPD
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Initialise LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBPGM = 'ER000171'
     C                   OUT       LDA
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 001
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Error Routine                      *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   RETURN
 
     C                   ENDSR
 
