     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Update Referral and Excess Trailer')          *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE3760T4 - Midas RE Update Referral and Excess Trailer       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CRE083BU *CREATE   Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE083BU - COB Restructure - RE COB Optimisation Phase 1     *
      *                                                               *
      *****************************************************************
 
     FODACTX    IF   F    4        DISK    INFSR(*PSSR)
     FREFRLTX   IF   F    4        DISK    INFSR(*PSSR)
     FFRLGTX    IF   F    4        DISK    INFSR(*PSSR)
     FODAC      O    F    4        DISK    INFSR(*PSSR)
     FREFRL     O    F    4        DISK    INFSR(*PSSR)
     FACRL      O    F    5        DISK    INFSR(*PSSR)
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** Local Data Area for Error Log
     D LDA             DS           256    Inz DTAARA(LDA)
     D  DBPGM                171    180A
 
      ** Data Structure for trailer file RTZZ mbr(ODAC)
     D ODACDS        E DS                  EXTNAME(RTZZ)
     D  NRODAC       E                     EXTFLD(NORE)
 
      ** Data Structure for trailer file RTZZ mbr(REFRL)
     D REFRLDS       E DS                  EXTNAME(RTZZ)
     D  RECID        E                     EXTFLD(RECI)
     D  RENORE       E                     EXTFLD(NORE)
 
      ** Data Structure for trailer file REFRLGZ mbr(ACRL)
     D ACRLDS        E DS                  EXTNAME(REFRLGZ)
     D  RECIA        E                     EXTFLD(RECI)
     D  GLNORE       E                     EXTFLD(GLNORE)
 
     D inPssr                          N
     D ONumRec         S             13P 0
     D RNumRec         S             13P 0
     D GNumRec         S             13P 0
 
     IODACTX    NS
     I                             P    2    4 0NRITO
     IREFRLTX   NS
     I                             P    2    4 0NOREFR
     IFRLGTX    NS
     I                             P    2    4 0NOREFG
 
      *****************************************************************
      *  MAIN PROCESSING                                              *
      *****************************************************************
 
      ** Accumulate total number of records
      ** from trailer file RTZZ mbr(ODACTX)
 
     C                   EVAL      ONumRec = 0
 
     C                   READ      ODACTX
     C                   DOW       NOT %EOF(ODACTX)
     C                   EVAL      ONumRec = ONumRec + NRITO
     C                   READ      ODACTX
     C                   ENDDO
 
      ** Add 2 to total number of records for header and trailer
 
     C                   EVAL      ONumRec = ONumRec + 2
 
      ** Update the trailer file RTZZ mbr(ODAC)
 
     C                   EVAL      RECI = 'T'
     C                   MOVE      ONumRec       NRODAC
     C                   WRITE     ODAC          ODACDS
 
      ** Accumulate total number of records
      ** from trailer file RTZZ mbr(REFRLTX)
 
     C                   EVAL      RNumRec = 0
 
     C                   READ      REFRLTX
     C                   DOW       NOT %EOF(REFRLTX)
     C                   EVAL      RNumRec = RNumRec + NOREFR
     C                   READ      REFRLTX
     C                   ENDDO
 
      ** Add 2 to total number of records for header and trailer
 
     C                   EVAL      RNumRec = RNumRec + 2
 
      ** Update the trailer file RTZZ mbr(REFRL)
 
     C                   EVAL      RECID = 'T'
     C                   MOVE      RNumRec       RENORE
     C                   WRITE     REFRL         REFRLDS
 
      ** Accumulate total number of records
      ** from trailer file REFRLGZ mbr(FRLGTX)
 
     C                   EVAL      GNumRec = 0
 
     C                   READ      FRLGTX
     C                   DOW       NOT %EOF(FRLGTX)
     C                   EVAL      GNumRec = GNumRec + NOREFG
     C                   READ      FRLGTX
     C                   ENDDO
 
      ** Add 1 to total number of records for trailer
 
     C                   EVAL      GNumRec = GNumRec + 1
 
      ** Update the trailer file REFRLGZ mbr(ACRL)
 
     C                   EVAL      RECIA = 'T'
     C                   MOVE      GNumRec       GLNORE
     C                   WRITE     ACRL          ACRLDS
 
      ** End Processing
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      *  *PSSR  - Program error                                       *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        NOT inPssr
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'RE3760T4'
     C                   OUT       LDA
     C                   DUMP
     C                   EVAL      inPssr = *ON
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   RETURN
 
     C                   ENDSR
