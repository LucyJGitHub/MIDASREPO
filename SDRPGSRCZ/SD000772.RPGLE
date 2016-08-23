     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Tax Ded by Ctry of Res Det Rpt - Prompt')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000772 - Tax Deducted by Country of Residence - Prompt     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER045             Date 20Jul09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Country of Tax Codes - Rtv
     FSDCTTXL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Country Codes - Rtv
     FSDCTRYL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Tax Deducted by Ctry of Residence Summary Rpt - Display
     FSD000772DFCF   E             WORKSTN
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Copyright Statement Array
     D CPY@            S             80A   DIM(1) CTDATA
 
      ** Local Data Area Data Structure
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
 
      ** Program Status Data Structure
     D PSDS           SDS
     D  PSProcName       *PROC
     D  PSPgmStat        *STATUS
     D  PSJobName            244    253
     D  PSUser               254    263
     D  PSProcPgm            334    343
     D  PSProcMod            344    353
 
      ** Program Output Data Structure
     D POutput         DS           100
     D  PTaxYear               1      4
     D  PCtryOfTax             5      6
     D  PRecCtry               7      8
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Country Details Data Structure
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PSequence       S              5A
     D PLevel          S              1A
     D PEntity         S              3A
     D PAct            S              1A
     D PCmd            S              1A
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PCtry           S              3A
 
      ** Standard Utility Parameters
     D PMsgFile        S             10A   INZ('GBSDUSRMSG')
     D PMsgID          S             10A
 
      ** Key Fields
     D KCNCD           S                   LIKE(A4CNCD)
     D KCTRT           S                   LIKE(EWCTRT)
 
      ** Working Variables
     D WIdx            S              1P 0
     D WTaxYr          S              4P 0
     D WScrn           S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------- Start of Main Processing -------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   EXSR      SRMain
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain - Handles main processing.                            *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR
 
      ** Clear the program message queue.
 
     C                   CALL      'ZA0250'
 
     C                   DOW       WScrn = 'P'
     C                   EXSR      SRDisplay
 
     C                   IF        *INKC = *ON
     C                   EVAL      WScrn = 'E'
     C                   ELSE
     C                   EXSR      SRValidate
     C                   ENDIF
 
     C                   ENDDO
 
      ** Set output parameters if necessary.
 
     C                   IF        WScrn = 'O'
     C                   EXSR      SROutput
     C                   ENDIF
 
      ** Return to the calling program if necessary.
 
     C                   IF        WScrn = 'E'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate - Handles validation processing.                  *
      *                                                               *
      *****************************************************************
     C     SRValidate    BEGSR
 
      ** Validate input fields.
 
     C                   EXSR      SRVTaxYr
     C                   EXSR      SRVCtryOfTax
     C                   EXSR      SRVRecCtry
 
      ** Update the output parameter if no errors occurred.
 
     C                   IF        *IN20 = *OFF AND
     C                             *IN21 = *OFF AND
     C                             *IN22 = *OFF
     C                   EVAL      WScrn = 'O'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROutput - Handles output processing.                        *
      *                                                               *
      *****************************************************************
     C     SROutput      BEGSR
 
     C                   EVAL      PTaxYear = #0TXYR
     C                   EVAL      PCtryOfTax = #0CTRT
     C                   EVAL      PRecCtry = #0RCTR
 
     C                   EVAL      WScrn = 'E'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMsg - Sends messages to the screen via ZA0340.          *
      *                                                               *
      *****************************************************************
     C     SRSndMsg      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgID
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Handles display processing.                      *
      *                                                               *
      *****************************************************************
     C     SRDisplay     BEGSR
 
      ** Display the screen.
 
     C                   WRITE     SD000772C1
     C                   WRITE     SD000772F1
     C                   EXFMT     SD000772F0
 
      ** Clear the program message queue.
 
     C                   CALL      'ZA0250'
 
      ** Reset the error indicators.
 
     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVTaxYr - Validates Tax Year.                               *
      *                                                               *
      *****************************************************************
     C     SRVTaxYr      BEGSR
 
      ** Tax Year is mandatory.
 
     C                   IF        #0TXYR = *BLANKS
     C                   EVAL      *IN20 = *ON
     C                   EVAL      PMsgID = 'USR4718'
     C                   EXSR      SRSndMsg
     C                   GOTO      EndVTax
     C                   ENDIF
 
      ** Tax Year must be numeric.
 
     C                   EVAL      WIdx = %CHECK('0123456789' : #0TXYR)
 
     C                   IF        WIdx <> *ZERO
     C                   EVAL      *IN20 = *ON
     C                   EVAL      PMsgID = 'USR4719'
     C                   EXSR      SRSndMsg
     C                   GOTO      EndVTax
     C                   ENDIF
 
      ** Tax Year must be between 2000 and 2099.
 
     C                   MOVE      #0TXYR        WTaxYr
 
     C                   IF        WTaxYr < 2000 OR
     C                             WTaxYr > 2099
     C                   EVAL      *IN20 = *ON
     C                   EVAL      PMsgID = 'USR4719'
     C                   EXSR      SRSndMsg
     C                   GOTO      EndVTax
     C                   ENDIF
 
     C     EndVTax       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCtryOfTax - Validates Country of Tax.                     *
      *                                                               *
      *****************************************************************
     C     SRVCtryOfTax  BEGSR
 
      ** Country of Tax is mandatory.
 
     C                   IF        #0CTRT = *BLANKS
     C                   EVAL      *IN21 = *ON
     C                   EVAL      PMsgId = 'USR4720'
     C                   EXSR      SRSndMsg
     C                   GOTO      EndVCtry
     C                   ENDIF
 
      ** Country of Tax must be a valid Country of Tax Code.
 
     C                   EVAL      KCTRT = #0CTRT
     C     KCTRT         CHAIN     SDCTTXL1
 
     C                   IF        NOT %FOUND
     C                   EVAL      *IN21 = *ON
     C                   EVAL      PMsgId = 'USR4721'
     C                   EXSR      SRSndMsg
     C                   GOTO      EndVCtry
     C                   ENDIF
 
     C     EndVCtry      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVRecCtry - Validates the Receiving Country.                *
      *                                                               *
      *****************************************************************
     C     SRVRecCtry    BEGSR
 
      ** Receiving Country must be a valid Country Code.
 
     C                   IF        #0RCTR <> *BLANKS
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      #0RCTR        PCtry
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      *IN22 = *ON
     C                   EVAL      PMsgID = 'USR4722'
     C                   EXSR      SRSndMsg
     C                   GOTO      EndVRcv
     C                   ENDIF
 
     C                   ENDIF
 
     C     EndVRcv       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Entry Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PSequence
     C                   PARM                    PLevel
     C                   PARM                    PEntity
     C                   PARM                    POutput
     C                   PARM                    PAct
     C                   PARM                    PCmd
 
      ** Access bank details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 101
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CLEAR                   POutput
 
     C                   EVAL      WScrn = 'P'
 
     C                   EVAL      #0USER = PSUser
     C                   EVAL      #0WSID = PSJobName
     C                   EVAL      #1PGMQ = '*'
 
     C                   EVAL      *IN90 = *ON
 
      ** Set the program, module, and procedure names for DB error handling.
 
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2004
