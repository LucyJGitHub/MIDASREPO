     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE PDCL process - Loans account keys')           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000489 - Check if there are PDCL events due today          *
      *                                                               *
      *  Function:  This program reads the files LELOMKPD, LEPK1DPD,  *
      *             LEPK2DPD, LEPK3DPD, LEACCTPD and check whether    *
      *             they contain records. If they are all empty,      *
      *             the PDCL process is skipped.                      *
      *             LELOMKPD: only records where IUSR = 'LE000457' are*
      *             selected                                          *
      *                                                               *
      *  Called By: LEC07002, LEC07003, LEC07004, LEC07005, LEC07006, *
      *             LEC07008, LEC07010, LEC07012, LEC07014, LEC07016, *
      *             LEC07018, LEC07020, LEC07022, LEC07024, LEC0476,  *
      *             LEC0471A, LEC0471B, LEC0472                       *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE164             Date 18Aug14               *
      *                 MD023203           Date 24Apr14               *
      *                 AR1056323          Date 14Nov12               *
      *                 AR1021983          Date 01Aug12               *
      *                 263074             Date 01Aug12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *           (Recompile)                                         *
      *  MD023203 - Update LEPDCL data area (Recompile)               *
      *  AR1056323 - Revert back changes of CLE134 for LKEY1DP and    *
      *              LKEYFED (Recompile)                              *
      *  AR1021983 - [PDP] Option C - Technical Enhancements Stated   *
      *              in POC                                           *
      *  263074 - Original Loans posting errors                       *
      *         - Wrong Postings when interest and principal are paid *
      *           on the same day (Recompile)                         *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
 
     FLEPK1DPD  IF   E             DISK    RENAME(LKEY1DPF:LEPK1DPF)
     FLEPK2DPD  IF   E             DISK    RENAME(LKEYFEDF:LKEYF2DF)
     FLEPK3DPD  IF   E             DISK
     FLELOMKPD  IF   E             DISK
 
      ** Local data area for PDCL Transactions Indicator
 
     D LEPDCL        E DS                  EXTNAME(LEPDCL)
 
      ** Work variables                                                                    AR1021983
     D WFRNT           S              8A   INZ('')                                         AR1021983
      *****************************************************************
      *                M A I N  P R O C E S S I N G                   *
      *****************************************************************
 
     C     *DTAARA       DEFINE                  LEPDCL
     C     *LOCK         IN        LEPDCL
     C                   EVAL      PDCLIN = 'N'
 
      ** Read LEPK1DPD which contains loans repayments subject to funds
      ** pre-check
 
     C     *START        SETLL     LEPK1DPD
     C                   READ      LEPK1DPD                               88
     C                   IF        *IN88 = *OFF
     C                   EXSR      SRUPDAT
     C                   ENDIF
 
      ** Read LEPK2DPD which contains calculated fees repayments
      ** subject to funds pre-check
 
     C                   EVAL      *IN88 = *OFF
     C     *START        SETLL     LEPK2DPD
     C                   READ      LEPK2DPD                               88
     C                   IF        *IN88 = *OFF
     C                   EXSR      SRUPDAT
     C                   ENDIF
 
      ** Read LEPK3DPD which contains non calculated fees repayments
      ** subject to funds pre-check
 
     C                   EVAL      *IN88 = *OFF
     C     *START        SETLL     LEPK3DPD
     C                   READ      LEPK3DPD                               88
     C                   IF        *IN88 = *OFF
     C                   EXSR      SRUPDAT
     C                   ENDIF
 
      ** Read LELOMKPD which contains loans amendments generated
      ** by the PDCL process
 
     C                   EVAL      *IN88 = *OFF
     C     *START        SETLL     LELOMKPD
     C                   READ      LELOMKPD                               88
     C     *IN88         DOWEQ     *OFF
     C                   IF        *IN88 = *OFF
     C                   EVAL      WFRNT = FRNT                                            AR1021983
     C**********         IF        IUSR = 'LE0457' OR IUSR = 'LE0473'                      AR1021983
     C                   IF        IUSR = 'LE000457' OR WFRNT = 'LE000473'                 AR1021983
     C                   EXSR      SRUPDAT
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      LELOMKPD                               88
     C                   ENDDO
 
     C                   OUT       LEPDCL
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDAT - Change PDCL indicator field to 'Y' then write it   *
      *            to LEPDCL data area                                *
      *            Set-on last record indicator                       *
      *            Return to calling program                          *
      *                                                               *
      *****************************************************************
     C     SRUPDAT       BEGSR
 
     C                   EVAL      PDCLIN = 'Y'
     C                   OUT       LEPDCL
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
