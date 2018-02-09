     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Interest Payment History Threshold Reset')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000817 - Midas SD Interest Payment History Threshold Reset *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER069             Date 03Jul14               *
      *                 AR750273A          Date 20May11               *
      *                 AR756585           Date 12May11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24249           Date 09Jun09               *
      *                 BUG24238           Date 08Jun09               *
      *                 BUG23732           Date 23Apr09               *
      *                 CER048  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER069 - German Tax Enhancement                              *
      *  AR750273A - SDC000817 00001 failed (Child: AR750274)         *
      *  AR756585 - SDC000817 00001 DBERR 001 in SDCUSTPD             *
      *             (Child: AR756586)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24249 - New fields in Limit Utilisation Enquiry and       *
      *             Report did not clear to zero                      *
      *  BUG24238 - Component SDC000817 000001 failed.                *
      *  BUG23732 - Joint Account threshold (Recompile)               *
      *  CER048 - German Features - Taxes                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7+U8 - Database Error Indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas SD Customer Detail by country of tax
      *
     FSDACTXL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD Interest Payment History File by Customer
      *
     FSDINPHL0  UF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,and the following
      ** named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Second DS for access programs - long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG24238
      *
      ** Externally described DS for Customer Deatils
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameter for AOCUSTR0
      *
     D PRtCd           S              7A
     D POptn           S              7A
     D PKey1           S             10A
     D PKey2           S              7A
      *
      ** Parameter for Keylist KLACTX
      *
     D KFCust          S              6A
     D KFCtry          S              2A
      *
     D WRun            S              1A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Initialize DBPGM with program name
      *
     C                   EVAL      DBPGM = 'SD000817'
      *
      ** Define Keylist KLAcTx
      *
     C     KLAcTx        KLIST
     C                   KFLD                    KFCust
     C                   KFLD                    KFCtry
      *
      ** Read Interest Payment History File (SDINPHL0)
      *
     C     *LOVAL        SETLL     SDINPHL0
     C                   READ      SDINPHL0
      *
     C                   DOW       NOT %EOF(SDINPHL0)
      *
     C**********         CALL      'AOCUSTR0'                                               BUG24238
     C**********         CALL      'AOCUSTR1'                                     BUG24238 AR750273A
     C                   CALL      'AOCUSTR0'                                              AR750273A
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      TICUST        PKey1
     C                   PARM      *BLANKS       PKey2
     C*****SDCUST        PARM      SDCUST        DSSDY                                      BUG24238
     C*****SDCUST        PARM      SDCUST        DSLDY                            BUG24238 AR750273A
     C     SDCUST        PARM      SDCUST        DSSDY                                     AR750273A
      *
     C                   IF        PRtCd <> *BLANKS
     C                             AND PRtCd <> '*CUSDEL'                                  AR750273A
     C                             AND PRtCd <> '*CUSCLS'                                  AR750273A
     C**********                   AND PRtCd <> '*CUSCLO'                         BUG24238 AR750273A
     C**********                   AND BBDTDL = 0                                 AR756585 AR750273A
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY = TICUST
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   EVAL      KFCust = TICUST
     C                   EVAL      KFCtry = BBCOLC
      *
     C     KLAcTx        CHAIN     SDACTXL1
      *
      ** Update/Delete record on Interest Payment History File
      *
     C                   IF        %FOUND(SDACTXL1) AND
     C                             AXETXS = 'S' OR
     C                             AXETXS = 'T' OR
     C                             AXETXS = 'Y' OR                                            CER069
     C                             AXETXS = 'D'
      *
     C                   EVAL      TIPGNO = *ZEROS
     C                   EVAL      TIUTTH = *ZEROS
     C                   EVAL      TITOUT = *ZEROS
     C                   EVAL      TIGSIN = *ZEROS                                          BUG24249
     C                   EVAL      TITTAX = *ZEROS                                          BUG24249
      *
     C                   UPDATE    SDINPHD0
      *
     C                   ELSE
      *
     C                   DELETE    SDINPHD0
      *
     C                   ENDIF
      *
     C                   READ      SDINPHL0
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
