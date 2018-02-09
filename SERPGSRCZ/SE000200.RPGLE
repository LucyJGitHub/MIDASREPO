     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Initialisation Program for CSW210')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities and Trading Module                        *
      *                                                               *
      *  SE000200 - Midas Initialisation Program for CSW210           *
      *                                                               *
      *  Function:  This program will initialise new fields           *
      *             introduced by CSW210.                             *
      *                                                               *
      *  Called By: SEC000200 - Midas Initialisation Program for      *
      *                         CSW210 Control                        *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSW210  *CREATE    Date 04May10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW210 - Swift 2010 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR    - Error processing                                   *
      * *INZSR   - Initialise                                         *
      * SrTradInit - Trade Extended Settement                         *
      * SrDepoInit - SE Depot Movements Extended Settlements          *
      * SrPosnInit - SE Position Settles Extended Settlements         *
      *                                                               *
      *****************************************************************
 
     FTRADSDX2  UF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Trades Extended Settlements
 
     FDPTMVDX2  UF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Depot Movements Extended Settlements
 
     FPOSETDX2  UF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Position Settles Extended Settlements
 
      *****************************************************************
      /EJECT
      *****************************************************************
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Data Structure for Access Programs
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure for Access Programs
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D WTempA          S              2A
 
     D PRetCodeIn      S              7A
     D PRespModeIn     S              1A
     D WValidIBAN      S              1A
 
     D WRtnCd          S              7A
     D WCheckIBAN      S                   LIKE(T2AP1L)
     D WTempIBAN       S             47A
     D WOutBlanks      S             47A
     D WOutNBlank      S             34A
 
     D Upper           C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D Lower           C                   'abcdefghijklmnopqrstuvwxyz'
     D Digits          C                   '1234567890'
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   IF        PRespModeIn = '1'
     C                   EXSR      SrTradInit
     C                   EXSR      SrDepoInit
     C                   EXSR      SrPosnInit
     C                   ENDIF
 
     C                   SETON                                        LR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrTradInit - Trade Extended Settement                         *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrTradInit    BEGSR
 
     C     *START        SETLL     TRADSDX2
     C                   READ      TRADSDX2
     C                   DOW       NOT %EOF( TRADSDX2 )
 
     C                   IF        T2AP1L <> *BLANKS
     C                   EVAL      WCheckIBAN = T2AP1L
     C                   EXSR      SRChkIBAN
     C                   EVAL      T2FAP1 = WValidIBAN
     C                   ELSE
     C                   EVAL      T2FAP1 = *BLANKS
     C                   ENDIF
 
     C                   IF        T2AFPL <> *BLANKS
     C                   EVAL      WCheckIBAN = T2AFPL
     C                   EXSR      SRChkIBAN
     C                   EVAL      T2FAP2 = WValidIBAN
     C                   ELSE
     C                   EVAL      T2FAP2 = *BLANKS
     C                   ENDIF
 
     C                   IF        T2DLIN <> *BLANKS
     C                   EVAL      WCheckIBAN = T2DLIN
     C                   EXSR      SRChkIBAN
     C                   EVAL      T2FDBT = WValidIBAN
     C                   ELSE
     C                   EVAL      T2FDBT = *BLANKS
     C                   ENDIF
 
     C                   IF        T2AWIL <> *BLANKS
     C                   EVAL      WCheckIBAN = T2AWIL
     C                   EXSR      SRChkIBAN
     C                   EVAL      T2FAI1 = WValidIBAN
     C                   ELSE
     C                   EVAL      T2FAI1 = *BLANKS
     C                   ENDIF
 
     C                   IF        T2BOF1 <> *BLANKS
     C                   EVAL      WCheckIBAN = T2BOF1
     C                   EXSR      SRChkIBAN
     C                   EVAL      T2FBF1 = WValidIBAN
     C                   ELSE
     C                   EVAL      T2FBF1 = *BLANKS
     C                   ENDIF
 
     C                   UPDATE    TRADSDD2
 
     C                   READ      TRADSDX2
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDepoInit - SE Depot Movements Extended Settlements          *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrDepoInit    BEGSR
 
     C     *START        SETLL     DPTMVDX2
     C                   READ      DPTMVDX2
     C                   DOW       NOT %EOF( DPTMVDX2 )
 
     C                   IF        D2AFPL <> *BLANKS
     C                   EVAL      WCheckIBAN = D2AFPL
     C                   EXSR      SRChkIBAN
     C                   EVAL      D2FAP1 = WValidIBAN
     C                   ELSE
     C                   EVAL      D2FAP1 = *BLANKS
     C                   ENDIF
 
     C                   IF        D2DLIN <> *BLANKS
     C                   EVAL      WCheckIBAN = D2DLIN
     C                   EXSR      SRChkIBAN
     C                   EVAL      D2FDBT = WValidIBAN
     C                   ELSE
     C                   EVAL      D2FDBT = *BLANKS
     C                   ENDIF
 
     C                   IF        D2AWIL <> *BLANKS
     C                   EVAL      WCheckIBAN = D2AWIL
     C                   EXSR      SRChkIBAN
     C                   EVAL      D2FAI1 = WValidIBAN
     C                   ELSE
     C                   EVAL      D2FAI1 = *BLANKS
     C                   ENDIF
 
     C                   IF        D2BOF1 <> *BLANKS
     C                   EVAL      WCheckIBAN = D2BOF1
     C                   EXSR      SRChkIBAN
     C                   EVAL      D2FBF1 = WValidIBAN
     C                   ELSE
     C                   EVAL      D2FBF1 = *BLANKS
     C                   ENDIF
 
     C                   UPDATE    DPTMVDD2
 
     C                   READ      DPTMVDX2
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPosnInit - SE Position Settles Extended Settlements         *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrPosnInit    BEGSR
 
     C     *START        SETLL     POSETDX2
     C                   READ      POSETDX2
     C                   DOW       NOT %EOF( POSETDX2 )
 
     C                   IF        P2AFPL <> *BLANKS
     C                   EVAL      WCheckIBAN = P2AFPL
     C                   EXSR      SRChkIBAN
     C                   EVAL      P2FAP1 = WValidIBAN
     C                   ELSE
     C                   EVAL      P2FAP1 = *BLANKS
     C                   ENDIF
 
     C                   UPDATE    POSETDD2
 
     C                   READ      POSETDX2
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkIBAN - Validate IBAN                                     *
      *                                                               *
      * Called by: SrTradInit                                         *
      *                                                               *
      * Calls: AOIBANR3                                               *
      *                                                               *
      *****************************************************************
 
     C     SRChkIBAN     BEGSR
 
     C                   EVAL      WValidIBAN = 'N'
 
     C                   IF        %SUBST(WCheckIBAN:1:1) = '/'
     C                   EVAL      WTempIBAN = %SUBST(WCheckIBAN:2)
     C                   ELSE
     C                   EVAL      WTempIBAN = WCheckIBAN
     C                   ENDIF
 
      ** Format IBAN
 
     C                   CALL      'AOIBANR3'
     C                   PARM      *BLANKS       WRtnCd
     C                   PARM                    WTempIBAN
     C                   PARM      *BLANKS       WOutBlanks
     C                   PARM      *BLANKS       WOutNBlank
 
     C                   IF        WRtnCd <> *BLANKS
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'AOIBANR3'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   MOVEL     WOutNBlank    WTempA
     C                   EVAL      WTempA = %XLATE(Lower:Upper:WTempA)
     C                   IF        %CHECK(Upper:WTempA:1) = 0 AND
     C                             %CHECK(Digits:%SUBST(WOutNBlank:3:2):1) = 0
 
     C                   CALL      'AOIBANR5'
     C                   PARM      *BLANKS       WRtnCd
     C                   PARM                    WOutNBlank
 
     C                   IF        WRtnCd = *BLANKS
     C                   EVAL      WValidIBAN = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRetCodeIn
     C                   PARM                    PRespModeIn
 
     C     *DTAARA       DEFINE                  LDA
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
