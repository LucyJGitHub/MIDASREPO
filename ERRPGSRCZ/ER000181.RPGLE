     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ER Transaction Type Decision Take-On')           *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000181 - Midas ER Transaction Type Decision Take-On        *
      *                                                               *
      *  Function:  This program populates Transaction Type Decision  *
      *             Table with dealing and lending type/subtype/class *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG26779           Date 27Nov09               *
      *                 CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
      ** Midas SD Deal sub-types retrieval
 
     FSDDLSTL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas FD Deal type/subtype file
 
     FFDDTSTL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Loan types/sub-types retrieval
 
     FSDLOANL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas ER Transaction Type Decision Table
 
     FERDETTL0  UF A E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
 
     D WModule         S              2A
     D WTYP            S              2A
     D WSTP            S              2A
     D WCLS            S              4A
 
     D PRtCd           S              7A
     D POptn           S              7A
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * MAIN PROCEDURE                                                *
      *                                                               *
      *****************************************************************
 
      ** Process FX Deal Type/Subtypes
 
     C                   IF        BGDLFX = 'Y'
     C     *LOVAL        SETLL     FDDTSTL1
     C                   READ      FDDTSTL1
     C                   MOVE      DLST11        WSTP
     C                   DOW       NOT %EOF(FDDTSTL1)
     C     WSTP          CHAIN     SDDLSTL1
 
     C                   IF        %FOUND(SDDLSTL1)
 
     C                   IF        DTPE11 = 'FP' OR
     C                             DTPE11 = 'FS' OR
     C                             DTPE11 = 'CX' OR
     C                             DTPE11 = 'PI' OR
     C                             DTPE11 = 'SI' OR
     C                             DTPE11 = 'OP' OR
     C                             DTPE11 = 'OT' OR
     C                             DTPE11 = 'SW'
     C                   EVAL      N4MMOD = 'FX'
     C                   EVAL      N4TRTY = DTPE11
     C                   EVAL      N4TRST = DLST11
     C                   EVAL      N4TRCL = CLAS11
     C                   EVAL      N4GRI = ' '
     C                   EVAL      N4BUCL = '  '
     C                   EVAL      N4BUSU = *ZEROS
     C                   EVAL      N4BUTY = *BLANKS                                         BUG26779
     C                   EVAL      N4LCD = BJRDNB
     C                   EVAL      N4TYLC = 'I'
     C
     C                   EVAL      WModule = 'FX'
     C                   EVAL      WTYP = DTPE11
     C                   EVAL      WSTP = DLST11
     C                   EVAL      WCLS = *BLANKS
 
     C     KDETT         CHAIN     ERDETTL0
     C                   IF        NOT %FOUND(ERDETTL0)
     C                   WRITE     ERDETTD0
     C                   ENDIF
     C
     C                   ENDIF
     C                   ENDIF
     C
     C                   READ      FDDTSTL1
     C                   ENDDO
     C                   ENDIF
 
      ** Process MM Deal Type/Subtypes
 
     C                   IF        BGDLMM = 'Y'
     C     *LOVAL        SETLL     FDDTSTL1
     C                   READ      FDDTSTL1
     C                   MOVE      DLST11        WSTP
     C                   DOW       NOT %EOF(FDDTSTL1)
     C     WSTP          CHAIN     SDDLSTL1
 
     C                   IF        %FOUND(SDDLSTL1)
 
     C                   IF        DTPE11 = 'IP' OR
     C                             DTPE11 = 'IT' OR
     C                             DTPE11 = 'TD' OR
     C                             DTPE11 = 'TI' OR
     C                             DTPE11 = 'CI' OR
     C                             DTPE11 = 'CD' OR
     C                             DTPE11 = 'CL'
     C                   EVAL      N4MMOD = 'MM'
     C                   EVAL      N4TRTY = DTPE11
     C                   EVAL      N4TRST = DLST11
     C                   EVAL      N4TRCL = CLAS11
     C**********         EVAL      N4GRI = 'Y'                                              BUG26779
     C                   EVAL      N4GRI = ' '                                              BUG26779
     C**********         EVAL      N4BUCL = 'BU'                                            BUG26779
     C                   EVAL      N4BUCL = *BLANKS                                         BUG26779
     C                   EVAL      N4BUSU = *ZEROS
     C                   EVAL      N4BUTY = *BLANKS                                         BUG26779
     C                   EVAL      N4LCD = BJRDNB
     C                   EVAL      N4TYLC = 'I'
     C
     C                   EVAL      WModule = 'MM'
     C                   EVAL      WTYP = DTPE11
     C                   EVAL      WSTP = DLST11
     C                   EVAL      WCLS = *BLANKS
 
     C     KDETT         CHAIN     ERDETTL0
     C                   IF        NOT %FOUND(ERDETTL0)
     C                   WRITE     ERDETTD0
     C                   ENDIF
     C
     C                   ENDIF
     C                   ENDIF
     C
     C                   READ      FDDTSTL1
     C                   ENDDO
 
     C                   ENDIF
 
      ** Process Loan Type/Subtypes
 
     C                   IF        BGCSLN = 'Y'
 
     C     *LOVAL        SETLL     SDLOANL1
     C                   READ      SDLOANL1
     C                   DOW       NOT %EOF(SDLOANL1)
 
     C                   EVAL      WModule = 'LE'
     C                   EVAL      WTYP = AYLNTY
     C                   EVAL      WSTP = AYLNST
     C                   EVAL      WCLS = *BLANKS
 
     C     KDETT         CHAIN     ERDETTL0
     C
     C                   IF        NOT %FOUND(ERDETTL0)
     C                   EVAL      N4MMOD = WModule
     C                   EVAL      N4TRTY = AYLNTY
     C                   EVAL      N4TRST = AYLNST
     C                   EVAL      N4TRCL = AYLNCL
     C**********         EVAL      N4GRI = 'Y'                                              BUG26779
     C                   EVAL      N4GRI = ' '                                              BUG26779
     C**********         EVAL      N4BUCL = 'BU'                                            BUG26779
     C                   EVAL      N4BUCL = *BLANKS                                         BUG26779
     C                   EVAL      N4BUSU = *ZEROS
     C                   EVAL      N4BUTY = *BLANKS                                         BUG26779
     C                   EVAL      N4LCD = BJRDNB
     C                   EVAL      N4TYLC = 'I'
     C
     C                   WRITE     ERDETTD0
     C                   ENDIF
 
     C                   READ      SDLOANL1
     C                   ENDDO
 
     C                   ENDIF
 
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
     C                   EVAL      DBPGM = 'ER000181'
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
 
      ** Get Module Details
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        PRtCd <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 002
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     KDEAL         KLIST
     C                   KFLD                    WTYP
     C                   KFLD                    WSTP
     C                   KFLD                    WCLS
 
     C     KDETT         KLIST
     C                   KFLD                    WModule
     C                   KFLD                    WTYP
     C                   KFLD                    WSTP
     C                   KFLD                    WCLS
 
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
