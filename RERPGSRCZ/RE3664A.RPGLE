     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Cr Int Capitalised and Tax Postings Merge')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE3664A - Midas RE Int Capitalised and Tax Postings Merge    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027A            Date 09May06               *
      *  Prev Amend No. 236471             Date 13Oct05               *
      *                 CGL031 *CREATE     Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  236471 - Tax amount added on record for CR interest adj.     *
      *           instead of record for interest => EU tax posting    *
      *           has wrong value date in TOF                         *
      *  CGL031 - Taxation on Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas TA Swiss Installation Control Data
     FSDSTAXL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas PB End of Day Interest Postings File
     FRPEODIPD  UF   E           K DISK    INFSR(*PSSR)
 
      ** Midas PB End of Day Interest Postings File by Accnt no
     FRPEODIL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RPEODID0:RPEODIX0)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** Account Data Structure
     D DSAccount       DS
     D   WEBRCA               01     03
     D   WECNUM               04     09
     D   WECCY                10     12
     D   WEACOD               13     22
     D   WEACSQ               23     24
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             02     02
     D  RecNotFnd             03     03
 
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
 
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Work Variables
     D WBranch         S              3A
     D*WCustomer*      S              6  0                                                   CSD027A
     D WCustomer       S              6A                                                     CSD027A
     D WCurrency       S              3A
     D WAccCode        S             10  0
     D WAccSeqn        S              2  0
     D WEUWTrnTyp      S              5  0
     D WPostAmt        S             13P 0
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Read records
 
     C     *START        SETLL     RPEODIPD
     C                   READ      RPEODIPD                               02
 
     C                   DOW       EndOfFile = False
 
      ** Process only records with the same transation type
      ** as the EU withholding tax transaction type.
 
     C                   IF        PITRAT = WEUWTrnTyp
 
     C                   EVAL      WBranch = PIBRCA
     C                   EVAL      WCustomer = PICNUM
     C                   EVAL      WCurrency = PICCY
     C                   EVAL      WAccCode = PIACOD
     C                   EVAL      WAccSeqn = PIACSQ
     C                   EVAL      WPostAmt = PIORAM
 
      ** Update file
 
     C                   EXSR      SRUpdate
 
      ** Delete Record
 
     C                   DELETE    RPEODID0
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      RPEODIPD                               02
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update File RPEODIPD                              *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
 
     C*****KAccount      CHAIN     RPEODIL0                           04                      236471
     C     KAccount      SETGT     RPEODIL0                           04                      236471
     C     KAccount      READPE    RPEODIL0                             04                    236471
 
     C                   IF        *IN04 = *ON
 
     C                   EVAL      WEBRCA = WBranch
     C                   MOVE      WCustomer     WECNUM
     C                   EVAL      WECCY = WCurrency
     C                   MOVE      WAccCode      WEACOD
     C                   MOVE      WAccSeqn      WEACSQ
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = DSAccount
     C                   EVAL      DBFile = 'RPEODIPD'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   EVAL      PIORAM = WPostAmt
     C                   UPDATE    RPEODIX0
 
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
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
      ** Retrieve EU Withholding Tax Transaction Type
 
     C     *LOVAL        SETLL     SDSTAXL1
     C                   READ      SDSTAXL1                               02
 
     C                   IF        EndOfFile = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'RETAIL'
     C                   EVAL      DBFile = 'SDSTAXPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      TXTXTT        WEUWTrnTyp
     C                   ENDIF
 
     C     KAccount      KLIST
     C                   KFLD                    WBranch
     C                   KFLD                    WCustomer
     C                   KFLD                    WCurrency
     C                   KFLD                    WAccCode
     C                   KFLD                    WAccSeqn
 
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
 
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
 
     C                   DUMP
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
